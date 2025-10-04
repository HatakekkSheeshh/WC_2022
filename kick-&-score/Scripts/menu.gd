extends Node2D

@onready var start_btn    = $Control/VBoxContainer/Start
@onready var option_btn   = $Control/VBoxContainer/Options
@onready var quit_btn     = $Control/VBoxContainer/Quit
@onready var pause_layer = $Option
@onready var options_panel := $Option/OptionsPanel

func _ready() -> void:	
	start_btn.pressed.connect(start_btn_pressed)
	option_btn.pressed.connect(options_btn_pressed)
	quit_btn.pressed.connect(quit_btn_pressed)

	# Option
	pause_layer.visible = false
	options_panel.visible = false
	options_panel.mouse_filter = Control.MOUSE_FILTER_STOP

func start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tilemap.tscn")                  

func quit_btn_pressed() -> void:
	get_tree().quit()

func options_btn_pressed() -> void:
	pause_layer.show()
	options_panel.open()
	options_panel.request_close.connect(_close_options_in_menu, CONNECT_ONE_SHOT)

func _close_options_in_menu() -> void:
	options_panel.hide()
	pause_layer.hide()
