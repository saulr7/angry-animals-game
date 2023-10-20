extends Node

const DEFAULT_SCORE : int = 1000

var _level_scores : Dictionary = {}
var _level_selected : int = 0
var attempts : int = 0
var _cups_hits : int = 0
var _target_cups : int = 0

func  _ready():
	SignalManager.on_cup_destroy.connect(on_cup_destroy)

func check_and_add(level: int) -> void:
	if !_level_scores.has(level):
		_level_scores[level] = DEFAULT_SCORE
		
func level_selected(level: int) -> void:
	check_and_add(level)
	_level_selected = level
	attempts = 0
	_cups_hits = 0
	
		
	
func on_cup_destroy():
	print("here")
	_cups_hits += 1
	check_game_over()


func get_best_for_level(level : int) -> int:
	check_and_add(level)
	
	return _level_scores[level]
	
func get_attempts() -> int:
	return attempts
	
	
func get_level_selected() -> int:
	return _level_selected
	
func attemp_made() ->void:
	attempts +=1
	SignalManager.on_attempt_made.emit()
	
func check_game_over() -> void:
	print("over 2", _cups_hits, _target_cups)
	if _cups_hits >= _target_cups:
		print("over")
		SignalManager.on_game_over.emit()
		if _level_scores[_level_selected] > attempts:
			_level_scores[_level_selected] = attempts
	
func set_target_cups(t : int) -> void:
	_target_cups = t	
	check_game_over()
	
	
	
