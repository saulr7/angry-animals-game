extends RigidBody2D

const DRAG_LIM_MAX : Vector2 = Vector2(0,60)
const DRAG_LIM_MIN : Vector2 = Vector2(-60,0)
const IMPULSE_MUL : float = 20.0
const FIRE_DELAY : float = 0.25
const STOPPED : float = 0.1
const IMPULSE_MAX : float = 1200

var _dead : bool = false
var _dragging: bool = false
var _released: bool = false
var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _last_dragged_position: Vector2 = Vector2.ZERO
var _last_drag_amount: float = 0.0
var _fired_time: float = 0.0
var _arrow_scale_x: float = 0.0
var _last_collision_count : int = 0

@onready var audio_player = $StretchSound
@onready var release_player = $ReleaseSound
@onready var collision_player = $CollisionSound
@onready var arrow_sprite = $ArrowSprite


func _ready():
	_start = global_position
	_arrow_scale_x = arrow_sprite.scale.x
	arrow_sprite.hide()

func _physics_process(delta):
	update_debug_label()
	
	if _released:
		_fired_time += delta
		if _fired_time > FIRE_DELAY:
			play_collision()
			check_on_target()
	else:
		if !_dragging:
			return
		else:
			if Input.is_action_just_released("drag"):
				release_it()
			else:
				drag_it()

func update_debug_label():
	var s = "g_pos:%s" % [Utils.vec2_to_str(global_position)] 
	s += "ang:%.1f linear %s \n" % [angular_velocity, Utils.vec2_to_str(linear_velocity)]
	s += "_draggin:%s release %s \n" % [_dragging, _released]
	s += "_start:%s _drag_start %s \n" % [Utils.vec2_to_str(_start), Utils.vec2_to_str(_drag_start)]
	s += "_last_dragged_position:%s _last_drag_amount %.1f \n" % [Utils.vec2_to_str(_last_dragged_position), _last_drag_amount]
	s += "_fired_time %.1f" % [_fired_time]
	
	SignalManager.on_update_debug_label.emit(s)

func scale_arrow():
	var imp_len = get_impluse().length()
	var perc = imp_len / IMPULSE_MAX
	arrow_sprite.scale.x = (_arrow_scale_x * perc)	+ _arrow_scale_x
	arrow_sprite.rotation = (_start - global_position).angle()

func play_collision() -> void:
	if _last_collision_count == 0 and get_contact_count() > 0 and !collision_player.playing:
		collision_player.play()
		
	_last_collision_count = get_contact_count()

func grab_it() -> void:
	_dragging = true
	_drag_start = get_global_mouse_position()
	_last_dragged_position = _drag_start
	arrow_sprite.show()
	
func drag_it() -> void:
	var gmp = get_global_mouse_position()
	_last_drag_amount = (_last_dragged_position - gmp).length()
	_last_dragged_position = gmp
	
	if _last_drag_amount > 0 and !audio_player.playing:
		audio_player.play()
	
	_dragged_vector = gmp - _drag_start
	_dragged_vector.x = clampf(
	_dragged_vector.x,
	DRAG_LIM_MIN.x	,
	DRAG_LIM_MAX.x	
	)
	_dragged_vector.y = clampf(
	_dragged_vector.y,
	DRAG_LIM_MIN.y	,
	DRAG_LIM_MAX.y	
	)
	global_position = _start + _dragged_vector
	
	scale_arrow()

func check_on_target() -> void:
	if !stopped_rolling():
		return
	
	var cb = get_colliding_bodies()
	if cb.size() == 0:
		return
		
	var cup = cb[0]
	if cup.is_in_group(GameManager.GROUP_CUP):
		cup.die()
		die()
	
	

func stopped_rolling()-> bool:
	if get_contact_count() > 0:
		if abs(linear_velocity.y) <STOPPED  and abs(angular_velocity) < STOPPED:
			return true
	return false

func release_it():
	_dragging = false
	_released = true
	freeze = false
	apply_central_impulse(get_impluse())
	audio_player.stop()
	release_player.play()
	ScoreManager.attemp_made()
	arrow_sprite.hide()
	
	
func get_impluse() -> Vector2:
	return _dragged_vector * -1 * IMPULSE_MUL
	
func die() -> void:
	if _dead:
		return 
		
	_dead = true
	SignalManager.on_animal_die.emit()
	queue_free()

func _on_screen_exited():
	die()

func _on_input_event(_viewport, event : InputEvent, _shape_idx):
	if _dragging or _released:
		return
		
	if event.is_action_pressed("drag"):
		grab_it()
