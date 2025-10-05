extends Node2D

@onready var spectrum = $spectrum_sound
@onready var back_btn = $home
@onready var setting_btn = $setting

@onready var pause_layer = $Option
@onready var options_panel := $Option/OptionsPanel

# Game Manager
var score: Array[int] = [0, 0]

func _ready() -> void:
	# Start game
	await get_tree().process_frame 
	%GameManager.reset()
	%GameManager.start()
	
	spectrum.finished.connect(_on_spectrum_finished)
	spectrum.play()

	# Buttons
	back_btn.pressed.connect(_on_back_pressed)
	setting_btn.pressed.connect(_open_options_in_game) 

	# Option
	pause_layer.visible = false
	options_panel.visible = false
	options_panel.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	options_panel.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_spectrum_finished() -> void:
	spectrum.play()

func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/menu.tscn")

func _open_options_in_game() -> void:
	get_tree().paused = true
	pause_layer.show()
	options_panel.open()
	options_panel.request_close.connect(_close_options_in_game, CONNECT_ONE_SHOT)

func _close_options_in_game() -> void:
	options_panel.hide()
	pause_layer.hide()
	get_tree().paused = false
