extends CanvasLayer
class_name hud

@onready var flag_textures: Array[TextureRect] = [%homeflag, %awayflag]
@onready var player_label: Label = $%playerlabel 
@onready var score_label: Label = $%scorelabel
@onready var time_label: Label = %timelabel

@onready var gm = %GameManager

func _ready() -> void:
	# Default
	player_label.text = "Group7"
	player_label.add_theme_color_override("font_color", Color.SKY_BLUE)
	time_label.text = "10:10"

	# Init
	update_score()
	update_clock()
	 
	# subscribe
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

func _on_score_changed(sc: Array[int]) -> void:
	score_label.text = ScoreHelper.get_score_text(sc)

func _on_time_up() -> void:
	# show panel, whistle, v.v. 
	pass
