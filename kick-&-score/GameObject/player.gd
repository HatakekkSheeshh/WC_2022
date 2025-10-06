extends CharacterBody2D
class_name Player

enum ControlScheme {P1, P2, CPU}

@export var control_scheme: ControlScheme

@export var speed: float = 80.0
@export var gain: float = 0.75			# rate: ball ≈ GAIN * player_velocity
@export var max_ball_speed: int = 500  			# max velocity for the ball (px/s)
@export var sprint_mult: float = 1.8
# Stamina
@export var max_stamina: float = 100.0
@export var stamina_drain: float = 30.0            	# decrease/th.s when sprinting
@export var stamina_recover_move: float = 5.0     	# recover/th.s when walking
@export var stamina_recover_idle: float = 25.0     	# recover/th.s when idling
@export var stamina_min_to_sprint: float = 10.0
@export var kick_power: float = 1.5

var stamina: float = 0.0
@onready var bar: ProgressBar = $ProgressBar
@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D

var current_dir
var pushing_ball = false
var ball: RigidBody2D = null

# State
var movement = false
var sprint = true

func _ready() -> void:
	print("Initialize Player object")
	
	# Initialize stamina
	stamina = max_stamina
	bar.min_value = 0
	bar.max_value = max_stamina
	bar.value = stamina

	$AnimatedSprite2D.play("idle")
	
	# Make sure to set up collision detection
	$CollisionShape2D.disabled = false

func _physics_process(delta: float) -> void:
	if control_scheme == ControlScheme.CPU:
		animation_player.play("idle")
		stamina_recover(delta)
	else:
		player_movement(delta)
		
	handle_ball_interaction(delta)
	
func player_movement(delta: float) -> void:
	var direction = KeyUtils.get_input_vector(control_scheme)
	velocity = direction * speed
	if KeyUtils.is_action_pressed(control_scheme, KeyUtils.Action.SPRINT) and stamina >= stamina_min_to_sprint:
		sprint = true
		velocity *= sprint_mult
	else:
		sprint = false
		
	if velocity.x > 0: # go right
		current_dir = Vector2.RIGHT
		movement = true
	elif velocity.x < 0: # go left
		current_dir = Vector2.LEFT
		movement = true
	elif velocity.y < 0: # go up
		current_dir = Vector2.UP
		movement = true
	elif velocity.y > 0: # go down
		current_dir = Vector2.DOWN
		movement = true
	else:
		movement = false

	move_and_slide()
	stamina_bar(delta)
	play_anim()
	
func play_anim():
	var dir = current_dir
	if not movement: # if movement is false, play this and ignore other directions
		animation_player.play("idle")
	elif dir == Vector2.RIGHT:
		animation_player.flip_h = false
		animation_player.play("walk_side")
	elif dir == Vector2.LEFT:
		animation_player.flip_h = true
		animation_player.play("walk_side")
	elif dir == Vector2.DOWN:
		animation_player.play("walk_front")
	elif dir == Vector2.UP:
		animation_player.play("walk_back")
	
func stamina_bar(delta: float) -> void:
	if sprint:
		stamina -= stamina_drain * delta
	else:
		stamina += (stamina_recover_move if movement else stamina_recover_idle) * delta

	stamina = clamp(stamina, 0.0, max_stamina)
	bar.value = stamina

func stamina_recover(delta: float) -> void:
	stamina += (stamina_recover_idle) * delta
	stamina = clamp(stamina, 0.0, max_stamina)
	bar.value = stamina

func change_scheme(new_scheme: ControlScheme) -> void:
	control_scheme = new_scheme

func handle_ball_interaction(delta: float) -> void:
	# Check for ball collision
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D and collider.is_in_group("ball"):
			ball = collider
			
			var player_speed = velocity.length()
			
			var kick_dir = collision.get_normal().normalized()
			
			var kick_force = (player_speed + 50) * kick_power
			
			ball.apply_central_impulse(-kick_dir * kick_force)
			
			var push_vector = collision.get_normal() * 1.5
			global_position += push_vector
	
	# Reset pushing_ball if we're not colliding with the ball anymore
	if pushing_ball and get_slide_collision_count() == 0:
		pushing_ball = false
		ball = null
