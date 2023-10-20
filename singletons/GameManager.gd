extends Node

var main_scene : PackedScene = preload("res://scenes/main.tscn")

const GROUP_CUP = "cup"
const GROUP_ANIMAL = "animal"

func load_main_scene():
	get_tree().change_scene_to_packed(main_scene)
