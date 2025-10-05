# GymosCircle.gd - Attach this to a Node2D that's a child of your character
extends Node2D

@export var radius = 10
@export var segments = 32
@export var color: Color = Color(0.0, 0.1, 0.4, 0.7)
@export var line_width = 3.0
@export var rotation_speed = 1.0
var current_rotation = 0.0

var team_controller

func _ready() -> void:
	team_controller=get_node("/GameManager/PlayerTeam1")
func _process(delta):
	var parent_player = get_parent()
	if is_active_player(parent_player):
		visible = true
		current_rotation += delta * rotation_speed
		queue_redraw()
	else:
		visible = false

func is_active_player(player):
	# Check if this player has player control scheme (not CPU)
	return player.control_scheme != Player.ControlScheme.CPU

func _draw():
	var points = PackedVector2Array()
	var angle_delta = 2 * PI / segments
	
	for i in range(segments + 1):
		var angle = i * angle_delta + current_rotation
		var point = Vector2(cos(angle), sin(angle)) * radius
		points.append(point)
	
	# Draw the circle
	for i in range(segments):
		draw_line(points[i], points[i+1], color, line_width)
