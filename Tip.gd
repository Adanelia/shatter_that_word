extends Node2D

const SPEED = 160

var text : String = "Chinese"


#func _init(tip : String = "Chinese"):
#	text = tip


func _ready():
	$Label.rect_size.x = get_viewport_rect().size.x * 0.8
	$Label.text = text


func _process(delta):
	position.y -= SPEED * delta


func _on_VisibilityNotifier2D_screen_exited():
#	print("free")
	queue_free()
