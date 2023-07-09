extends Node


var enabled := true

onready var noise_gen = $Noise.get_stream_playback()


enum {
	Click,
	Switch,
	Sss,
	Explosion,
}


func play(audio):
	if not enabled:
		return
	
	match audio:
		Click:
			$Click.play()
		Switch:
			$Switch.play()
		Sss:
			$Sss.play()
		Explosion:
			$Explosion.play()


func play_noise(playing : bool):
	if playing:
		$Noise.play()
	else:
		$Noise.stop()


func _fill_buffer():
	var to_fill = noise_gen.get_frames_available()
	while to_fill > 0:
		noise_gen.push_frame(Vector2.ONE * randf())
		to_fill -= 1


func _process(_delta):
	_fill_buffer()
