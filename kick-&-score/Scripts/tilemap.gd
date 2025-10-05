extends Node2D

@onready var spectrum = $spectrum_sound
@onready var back_btn = $home
@onready var setting_btn = $setting

@onready var pause_layer = $Option
@onready var options_panel := $Option/OptionsPanel


# Game Manager
var score: Array[int] = [0, 0]
@onready var gm = %GameManager

# Goal
@onready var goal1 = $TileMap/Goals/Goal1
@onready var goal2 = $TileMap/Goals/Goal2

# Reset
var _spawn: Dictionary = {}               # { Node2D: Transform2D }
var _reset_nodes: Array[Node2D] = []      # [ Node2D, Node2D, ... ]


func _ready() -> void:
	# Start game
	# call_deferred("_boot_match")
	gm.start()
	
	spectrum.finished.connect(_on_spectrum_finished)
	spectrum.play()

	# Buttons
	back_btn.pressed.connect(_on_back_pressed)
	setting_btn.pressed.connect(_open_options_in_game) 

	# Option
	pause_layer.visible = false
	options_panel.visible = false
	options_panel.mouse_filter = Control.MOUSE_FILTER_STOP

	_reset_nodes = [
		$"GameManager/ball",
		$"GameManager/PlayerTeam1/player1",
		$"GameManager/PlayerTeam1/player2",
		$"GameManager/PlayerTeam2/player1",
		$"GameManager/PlayerTeam2/player2",
	]

	# Chụp transform ban đầu
	for n: Node2D in _reset_nodes:
		_spawn[n] = n.global_transform

	gm.game_reset.connect(_on_game_reset)
	goal1.scored.connect(_on_game_reset)
	goal2.scored.connect(_on_game_reset)
	
func _on_spectrum_finished() -> void:
	spectrum.play()

func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/menu.tscn")

func _open_options_in_game() -> void:
	gm.pause_game(true)
	get_tree().paused = true
	pause_layer.show()
	options_panel.open()
	options_panel.request_close.connect(_close_options_in_game, CONNECT_ONE_SHOT)

func _close_options_in_game() -> void:
	options_panel.hide()
	pause_layer.hide()
	gm.pause_game(false)
	get_tree().paused = false

func _on_game_reset() -> void:
	await get_tree().create_timer(1.0).timeout
	
	for n: Node2D in _reset_nodes:
		var xf: Transform2D = _spawn.get(n, n.global_transform)

		if n is RigidBody2D:
			# Đặt lại an toàn cho physics body (ball)
			n.freeze = true
			n.global_transform = xf
			n.linear_velocity = Vector2.ZERO
			n.angular_velocity = 0.0
			n.freeze = false
		else:
			n.global_transform = xf
			if n is CharacterBody2D:
				n.velocity = Vector2.ZERO
