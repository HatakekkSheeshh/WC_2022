extends Node

enum Action {LEFT, RIGHT, UP, DOWN, SPRINT, SWITCH}

const ACTIONS_MAP: Dictionary = {
	Player.ControlScheme.P1: {
		Action.LEFT: "ui_left_1",
		Action.RIGHT: "ui_right_1",
		Action.UP: "ui_up_1",
		Action.DOWN: "ui_down_1",
		Action.SPRINT: "ui_sprint_1",
		Action.SWITCH: "player_switch_1"
	},
	Player.ControlScheme.P2: {
		Action.LEFT: "ui_left_2",
		Action.RIGHT: "ui_right_2",
		Action.UP: "ui_up_2",
		Action.DOWN: "ui_down_2",
		Action.SPRINT: "ui_sprint_2",
		Action.SWITCH: "player_switch_2"
	}
} 

func get_input_vector(scheme: Player.ControlScheme) -> Vector2:
	var map: Dictionary = ACTIONS_MAP[scheme]
	return Input.get_vector(map[Action.LEFT], map[Action.RIGHT], map[Action.UP], map[Action.DOWN])

func is_action_pressed(scheme: Player.ControlScheme, action: Action) ->  bool:
	return Input.is_action_pressed(ACTIONS_MAP[scheme][action])

func is_action_just_pressed(scheme: Player.ControlScheme, action: Action) ->  bool:
	return Input.is_action_just_pressed(ACTIONS_MAP[scheme][action])
	
func is_action_just_released(scheme: Player.ControlScheme, action: Action) ->  bool:
	return Input.is_action_just_released(ACTIONS_MAP[scheme][action])
