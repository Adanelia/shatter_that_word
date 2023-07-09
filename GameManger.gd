extends Node2D


const WORD = preload("res://Word.tscn")
const LETTER = preload("res://Letter.tscn")
const LETTERS = "abcdefghijklmnopqrstuvwxyz"

var WordsFile := "res://data/senior.txt"

var in_game := false
var endless := false
var idx : int
var start_position := Vector2()
var wordpool = {}
var wordkey = []
var total_words := 40
var hit := 0
#var miss_words := 0

onready var AudioManager = $AudioManager

func _ready():
#	print(LETTERS[3])
#	win()
#	read_from("res://data/senior.txt", 5)
	$Message/CenterContainer.rect_size = get_viewport_rect().size


# 0.1.0版本实现，拖动结束才开始判定
#func _input(event):
#	if event is InputEventScreenTouch:
#		if event.is_pressed():
#			idx = event.get_index()
#			start_position = event.position
##			print("down", event.position)
#		else:
#			if idx == event.get_index():
#				var end_position = event.position
#				if (end_position - start_position).length() > 100:
#					$SuperLightning.spawn(start_position, end_position, 0.3)
#					$SuperLightning.lightning()
#					AudioManager.play(AudioManager.Sss)
#					if in_game:
#						var ray = RayCast2D.new()
#						add_child(ray)
#						ray.position = start_position
#						ray.cast_to = end_position - start_position
#						ray.force_raycast_update()
#						yield(get_tree().create_timer(0.2), "timeout")
#						var obj = ray.get_collider()
#						if (obj != null) and (obj.has_method("crash")):
#							AudioManager.play(AudioManager.Explosion)
#							obj.crash()
#							hit += 1
#						ray.queue_free()
##				print("up", event.position)


# 0.1.1版本，应很多玩家的反馈，按下后不停进行判定，可能会有性能问题，或许有更好的办法
func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			idx = event.get_index()
			start_position = event.position
#			AudioManager.play_noise(true)
#			print("down", event.position)
		else:
			if idx == event.get_index():
				yield(get_tree().create_timer(0.1), "timeout")
				AudioManager.play_noise(false)
#				print("up", event.position)
	elif event is InputEventScreenDrag:
		if idx == event.get_index():
			var end_position = event.position
			# 忽略微小移动，不然直接爆炸
			if (end_position - start_position).length() < 20:
				return
			$SuperLightning.spawn(start_position, end_position, 0.1)
			$SuperLightning.lightning()
			if in_game:
				var ray = RayCast2D.new()
				add_child(ray)
				ray.position = start_position
				ray.cast_to = end_position - start_position
				ray.force_raycast_update()
#				yield(get_tree().create_timer(0.2), "timeout")
				var obj = ray.get_collider()
				if (obj != null) and (obj.has_method("crash")):
					AudioManager.play(AudioManager.Explosion)
					obj.crash()
					hit += 1
				ray.queue_free()
			AudioManager.play_noise(true)
			start_position = end_position


func _on_start_game(arg):
	in_game = true
#	miss_words = 0
	hit = 0
	total_words = 0
	if arg > 0:
		wordpool = read_from(WordsFile, arg)
		endless = false
	else:
		wordpool = read_from(WordsFile)
		endless = true
	wordkey = wordpool.keys()
	$Spawn.start()


func _on_end_game():
	in_game = false
	$Spawn.stop()


func read_from(path : String, times : int = 50):
#	total_words = times
	
	randomize()
	var f = File.new()
	f.open(path, File.READ)
	var length = f.get_len()
#	print(length)
	var dic = {}
	
	for i in times:
#	for i in 10:# Debug---------------------------------------------------------
		f.seek(randi() % length)
		while not f.get_line():
			f.seek(randi() % length)
#		print(f.get_line())
		
		var text = f.get_csv_line()
#		print(text)
		dic[text[0]] = text[1]
	
#	print(dic)
	f.close()
#	print("get data")
	
	return dic


func emit_letter(pos, f = 1):
	var letter = LETTER.instance()
	letter.mode = RigidBody2D.MODE_RIGID
	letter.get_child(1).text = LETTERS[randi() % 26]
	letter.position = pos
	letter.rotation_degrees = rand_range(-180, 180)
	$Letters.add_child(letter)
	var center_pos = get_viewport_rect().size / 2 # Vector2(640, 180)
	center_pos.y /= 2
	var force = center_pos - pos
#	force += Vector2(rand_range(-300, 300), rand_range(-300, 300))
	force = force.rotated(rand_range(-PI / 4, PI / 4))
	force *= f
	letter.apply_central_impulse(force)


func emit_letter2(pos, f = 1):
	var letter = LETTER.instance()
	letter.mode = RigidBody2D.MODE_RIGID
	letter.get_child(1).text = LETTERS[randi() % 26]
	letter.position = pos
	letter.rotation_degrees = rand_range(-180, 180)
	$Letters.add_child(letter)
	var center_pos = get_viewport_rect().size / 2 # Vector2(640, 180)
	center_pos.y /= 2
	var force = (center_pos - pos).rotated(rand_range(-PI, PI))
	force *= f
	letter.apply_central_impulse(force)


func win():
#	for each in $Words.get_children():
#		if each.has_meta("crashed"):
#			print("is a word")
#			if not each.crashed:
#				miss_words += 1
#		else:
#			print("not a word")
#	print("total: ", hit, "/", total_words)
	$Message/CenterContainer/VBoxContainer/ScoreLabel.text = tr("SCORE") + ": " + str(hit) + "/" + str(total_words)
	
#	$Message/Label.text = "CONGRATULATIONS"
#	$Tween.interpolate_property($Message, "modulate", Color(1.0, 1.0, 1.0, 0.0), Color(1.0, 1.0, 1.0, 1.0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
#	$Tween.start()
#	$Message.show()
#	# TODO: Throw letters.
#	yield(get_tree().create_timer(2.0), "timeout")
#	$Tween.interpolate_property($Message, "modulate", Color(1.0, 1.0, 1.0, 1.0), Color(1.0, 1.0, 1.0, 0.0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
#	$Tween.start()
#	yield(get_tree().create_timer(1.0), "timeout")
#	$Message.hide()
	$Message/AnimationPlayer.play("win")
	for i in 18:
		yield(get_tree().create_timer(0.1), "timeout")
#		var letter1 = LETTER.instance()
#		var letter2 = LETTER.instance()
#		letter1.mode = RigidBody2D.MODE_RIGID
#		letter2.mode = RigidBody2D.MODE_RIGID
#		letter1.get_child(1).text = LETTERS[randi() % 26]
#		letter2.get_child(1).text = LETTERS[randi() % 26]
#		letter1.position = Vector2(-64, 784)
#		letter2.position = Vector2(1344, 784)
#		letter1.rotation_degrees = rand_range(-180, 180)
#		letter2.rotation_degrees = rand_range(-180, 180)
#		$Letters.add_child(letter1)
#		$Letters.add_child(letter2)
#		var force1 = Vector2(640, 180) - Vector2(-64, 784)
#		force1 += Vector2(rand_range(-300, 300), rand_range(-300, 300))
#		var force2 = Vector2(640, 180) - Vector2(1344, 784)
#		force2 += Vector2(rand_range(-300, 300), rand_range(-300, 300))
#		letter1.apply_central_impulse(force1)
#		letter2.apply_central_impulse(force2)
		
		var viewport_size = get_viewport_rect().size
		emit_letter(Vector2(-viewport_size.x * 0.2, viewport_size.y * 1.1))
		emit_letter(Vector2(viewport_size.x * 1.2, viewport_size.y * 1.1))
	
	yield(get_tree().create_timer(5), "timeout")
	for each in $Letters.get_children():
		each.queue_free()


func lose():
	$Message/CenterContainer/VBoxContainer/ScoreLabel.text = tr("SCORE") + ": " + str(hit) + "/" + str(total_words)
	$Message/AnimationPlayer.play("lose")
	for i in 24:
		emit_letter2(Vector2(get_viewport_rect().size.x / 25 * i, -64), 0.2)
	yield(get_tree().create_timer(6), "timeout")
	for each in $Letters.get_children():
		each.queue_free()


func _on_Spawn_timeout():
	if wordkey:
		var w = wordkey.pop_front()
		var word = WORD.instance()
		print(w)
		word.text = w
		word.meaning = wordpool[w]
		var viewport_size = get_viewport_rect().size
		var pos = Vector2(rand_range(-viewport_size.x * 0.2, viewport_size.x * 1.2), viewport_size.y * 1.1)
		word.position = pos
		word.rotation_degrees = rand_range(-75, 75)
		$Words.add_child(word)
		var center_pos = get_viewport_rect().size / 2 # Vector2(640, 180)
		center_pos.y /= 2
		var force = center_pos - pos
		force += Vector2(rand_range(-50, 50), rand_range(-50, 50))
		word.apply_central_impulse(force)
		
		if endless:
			if total_words - hit > 5:
				$Spawn.stop()
				lose()
		total_words += 1
	else:
		if endless:
			$Spawn.stop()
			wordpool = read_from(WordsFile)
#			print("continue")
			wordkey = wordpool.keys()
			$Spawn.start()
		else:
#			print("---end---")
			$Spawn.stop()
			yield(get_tree().create_timer(1), "timeout")
			win()

