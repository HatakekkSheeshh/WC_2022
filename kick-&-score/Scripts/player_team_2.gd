extends Node2D

var cooldown = 1.0
var time_left = 0.0
var can_change = false

@onready var char1 = $player1
@onready var char2 = $player2
@onready var char3 = $player3

func _ready() -> void:
	time_left = cooldown
	char2.process_mode = Node.PROCESS_MODE_DISABLED
	char3.process_mode = Node.PROCESS_MODE_DISABLED
	
func _process(delta: float) -> void:
	if time_left > 0.0:
		time_left -= delta
	elif time_left <= 0.0 && can_change == false:
		can_change = true
	
	if can_change && Input.is_action_just_pressed("player_switch_2") && char1.process_mode == Node.PROCESS_MODE_INHERIT:
		char1.process_mode = Node.PROCESS_MODE_DISABLED
		char2.process_mode = Node.AUTO_TRANSLATE_MODE_INHERIT
		reset_char_switch_delay()
	if can_change && Input.is_action_just_pressed("player_switch_2") && char2.process_mode == Node.PROCESS_MODE_INHERIT:
		char2.process_mode = Node.PROCESS_MODE_DISABLED
		char3.process_mode = Node.AUTO_TRANSLATE_MODE_INHERIT
		reset_char_switch_delay()
	if can_change && Input.is_action_just_pressed("player_switch_2") && char3.process_mode == Node.PROCESS_MODE_INHERIT:
		char3.process_mode = Node.PROCESS_MODE_DISABLED
		char1.process_mode = Node.AUTO_TRANSLATE_MODE_INHERIT
		reset_char_switch_delay()

func reset_char_switch_delay():
	time_left = cooldown
	can_change = false
