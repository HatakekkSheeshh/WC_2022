extends Node2D

# Signal
signal time_changed(seconds_left: int)
signal score_changed(score: Array[int], team: int)
signal time_up
signal game_reset

@onready var tick: Timer = $playtime
@export var match_minutes := 45
@export var real_seconds := 240
@export var tick_sec := 0.1


var time_elapsed: float = 0.0
var running := false
var score: Array[int] = [0, 0]
var team: int = -1
var _last_sec := -1 


func _ready() -> void:
	tick.wait_time = tick_sec
	tick.timeout.connect(_on_tick)
	_emit_time_if_changed()   

func start() -> void:
	running = true
	tick.paused = false       
	tick.start()

func pause_game(paused: bool = true) -> void:
	running = !paused
	tick.paused = paused

func reset() -> void:
	running = false
	tick.stop()
	time_elapsed = 0.0
	_last_sec = -1
	score = [0, 0]
	score_changed.emit(score, -1)
	_emit_time_if_changed()
	tick.paused = false
	
	game_reset.emit()

func goal(side: int) -> void:
	# side: 0 = home, 1 = away
	var team: int = -1
	if side == 0:
		score[1] += 1
		team = 1
	elif side == 1:
		score[0] += 1
		team = 0
	score_changed.emit(score, team)
	# ball.call_deferred # reset to center

func _on_tick() -> void:
	if !running: return
	var total = match_minutes * 60	# minute -> second
	var factor = total / real_seconds
	time_elapsed += factor * tick_sec
	
	if time_elapsed >= total:
		time_elapsed = total
		running = false
		tick.stop()
		_emit_time_if_changed()
		time_up.emit()
		return
	_emit_time_if_changed()

func _emit_time_if_changed() -> void:
	var s := int(floor(time_elapsed + 0.5)) 
	if s != _last_sec:
		_last_sec = s
		emit_signal("time_changed", s)
		
