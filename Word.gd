extends RigidBody2D

const SPEED = 1000
const LETTER_WIDTH = 32
const LETTER = preload("res://Letter.tscn")
const TIP = preload("res://Tip.tscn")

#var crashed : bool = false
var text : String = "word"
var meaning : String = "Chinese"
var length : int


#func _init(spell : String = "word", chinese_meaning : String = "Chinese"):
#	text = spell
#	meaning = chinese_meaning
##	length = text.length()


func _ready():
	length = text.length()
	mass = length
	var col_pos = Vector2(LETTER_WIDTH * length / 2, LETTER_WIDTH)
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.extents = col_pos
	$CollisionShape2D.position = col_pos
	
	for i in length:
		var letter_scene = LETTER.instance()
		letter_scene.get_node("Label").text = text[i]
		letter_scene.position = Vector2(32 * i, 0)
		letter_scene.get_node("CollisionShape2D").disabled = true
		$Letters.add_child(letter_scene)


func crash():
#	crashed = true
	$CollisionShape2D.disabled = true
	for i in $Letters.get_children():
		i.mode = RigidBody2D.MODE_RIGID
		i.get_node("CollisionShape2D").disabled = false
		var force = Vector2(rand_range(-1, 1), rand_range(-1, 1))
		i.apply_central_impulse(SPEED * force.normalized())
#	$Timer.start()
	var tip = TIP.instance()
	tip.text = meaning
	get_parent().add_child(tip)


func _on_Timer_timeout():
	if position.y > 720:
#		if not crashed:
#			get_parent().get_parent().miss()
		queue_free()
