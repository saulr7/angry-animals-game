extends CanvasLayer

@onready var level_label = $MC/VB/LevelLabel 
@onready var attempts_label = $MC/VB/AttempsLabel 
@onready var sound = $Sound
@onready var vb_2 = $MC/VB2


func _ready():
	level_label.text = "Level %s" % ScoreManager.get_level_selected()
	on_attempt_made()
	SignalManager.on_attempt_made.connect(on_attempt_made)
	SignalManager.on_game_over.connect(on_game_over)
	
func _process(_delta):
	if vb_2.visible and  Input.is_key_pressed(KEY_SPACE):
		GameManager.load_main_scene()
	
func on_attempt_made():
	attempts_label.text = "Attempts %s" % ScoreManager.get_attempts()

func on_game_over():
	vb_2.show()
	sound.play()
