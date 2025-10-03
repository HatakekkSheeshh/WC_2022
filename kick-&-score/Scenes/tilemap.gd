extends Node2D

@onready var spectrum = $spectrum_sound

func _ready() -> void:
	spectrum.finished.connect(spectrum_finish)
	spectrum.play()
	
func spectrum_finish():
	spectrum.play()
	
