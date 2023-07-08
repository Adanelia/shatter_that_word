extends Node2D


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		$Word.crash()
		$Word2.crash()
