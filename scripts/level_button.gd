extends TextureButton

const HOVER_SCALE : Vector2 = Vector2(1.1, 1.1)
const DEFAULT_SCALE : Vector2 = Vector2(1.0, 1.0)

@export var label_number : int = 1

@onready var level_label = $MC/VB/Level
@onready var score_label = $MC/VB/Score

var _level_scene : PackedScene


func _ready():
	level_label.text = str(label_number)
	score_label.text = str(ScoreManager.get_best_for_level(label_number))
	_level_scene = load("res://scenes/level_%s.tscn" % label_number)

func _on_pressed():
	ScoreManager.level_selected(label_number)
	get_tree().change_scene_to_packed(_level_scene)


func _on_mouse_entered():
	scale = HOVER_SCALE


func _on_mouse_exited():
	scale = DEFAULT_SCALE
