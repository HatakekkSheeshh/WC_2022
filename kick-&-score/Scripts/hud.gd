extends CanvasLayer
class_name hud

@onready var flag_textures: Array[TextureRect] = [%homeflag, %awayflag]
@onready var player_label: Label = $%playerlabel 
@onready var score_label: Label = $%scorelabel
@onready var time_label: Label = %timelabel
@onready var time_up_text: TextureRect = %time_up_texture
@onready var time_up_label: Label = %time_up_label
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var gm = %GameManager
@onready var whistle: AudioStreamPlayer = %whistle 
@onready var mask: ColorRect = %mask
@onready var goal_banner: TextureRect = %goal_texture 
@onready var goal_label: Label = %goal_label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Default
	player_label.text = "Group7"
	player_label.add_theme_color_override("font_color", Color.SKY_BLUE)
	time_label.text = "10:10"
	 
	# Init
	update_score()
	update_clock()
	goal_banner.visible = false	
	goal_label.visible = false
	time_up_text.visible = false
	time_up_text.visible = false
	mask.visible = false
	mask.mouse_filter = Control.MOUSE_FILTER_IGNORE
	anim.stop(true) 
	
	# time up
	gm.time_changed.connect(_on_time_changed)
	gm.score_changed.connect(_on_score_changed)
	gm.time_up.connect(_on_time_up)
	
	
func update_score() -> void:
	score_label.text = ScoreHelper.get_score_text(gm.score)

func update_clock() -> void:
	time_label.text = TimeHelper.get_time_text(gm.time_elapsed)

func _on_time_changed(s: int) -> void:
	time_label.text = TimeHelper.get_time_text(s)
	var total = gm.match_minutes * 60
	time_label.add_theme_color_override("font_color", Color.RED if (s >= total - 5) else Color.SKY_BLUE)

func _on_score_changed(sc: Array[int], team: int) -> void:
	score_label.text = ScoreHelper.get_score_text(sc)
	
	team += 1
	print("Team" + str(team))
	if team != -1: 
		_play_goal_anim(score_label.text, team)
	
func _on_time_up() -> void:
	time_label.add_theme_color_override("font_color", Color.RED)
	time_label.text = TimeHelper.get_time_text(int(gm.time_elapsed))

	time_up_text.visible = true	
	time_up_label.visible = true
	mask.visible = true		
	anim.play("game_over")
	
	if whistle:
		whistle.play()
	get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		_restart_match()

func _restart_match() -> void:
	if is_instance_valid(anim):
		anim.play("game_over")
	time_up_text.visible = false
	time_up_label.visible = false
	mask.visible = false
	
	get_tree().paused = false
	gm.pause_game(false)
	if "reset" in gm and gm.has_method("reset"):
		gm.reset()
	if "start" in gm and gm.has_method("start"):
		gm.start()

func _play_goal_anim(text: String, team: int) -> void:
	goal_banner.visible = true
	goal_label.visible = true 
	
	goal_label.text = "Team " + str(team) +" scored: " + text 
	
	anim.play("goal")
	await get_tree().create_timer(2.0).timeout
	goal_banner.visible = false
	goal_label.visible = false	
