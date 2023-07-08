extends Node


var enabled := true

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

