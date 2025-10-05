extends Node2D

var cooldown = 0.5
var time_left = 0.0
var can_change = false

var curr_char: int = 0

@onready var char1 = $player1
@onready var char2 = $player2

var cpu = Player.ControlScheme.CPU
var player = Player.ControlScheme.P2

func _ready() -> void:
	time_left = cooldown
	char2.change_scheme(cpu)
	
func _process(delta: float) -> void:
	if time_left > 0.0:
		time_left -= delta
	elif time_left <= 0.0 && can_change == false:
		can_change = true
	
	if can_change && KeyUtils.is_action_just_pressed(player, KeyUtils.Action.SWITCH) && char1.control_scheme == player:
		char1.change_scheme(cpu)
		char2.change_scheme(player)
		reset_char_switch_delay()
	if can_change && KeyUtils.is_action_just_pressed(player, KeyUtils.Action.SWITCH) && char2.control_scheme == player:
		char2.change_scheme(cpu)
		char1.change_scheme(player)
		reset_char_switch_delay()

func reset_char_switch_delay():
	time_left = cooldown
	can_change = false
