extends StaticBody2D


@onready var vanish_sound = $VanishSound
@onready var animation = $AnimationPlayer


func die() -> void:
	vanish_sound.play()
	animation.play("vanish")
	

func _on_vanish_sound_finished():
	SignalManager.on_cup_destroy.emit()
	queue_free()
