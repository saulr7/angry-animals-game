extends Node2D

var animal_sceen :PackedScene = preload("res://scenes/animal.tscn")

@onready var debug_label = $DebugLabel
@onready var animal_start = $AnimalStart


func _ready():
	set_up()
	SignalManager.on_update_debug_label.connect(on_update_debug_label)
	SignalManager.on_animal_die.connect(on_animal_die)
	on_animal_die()
	
func  _process(_delta):
	if Input.is_key_pressed(KEY_Q):
		GameManager.load_main_scene()

func set_up():
	var tc = get_tree().get_nodes_in_group(GameManager.GROUP_CUP)	
	ScoreManager.set_target_cups(tc.size())
	
func on_update_debug_label(text: String):
	debug_label.text = text

func on_animal_die():
	var animal = animal_sceen.instantiate()
	animal.global_position = animal_start.global_position
	add_child(animal)
