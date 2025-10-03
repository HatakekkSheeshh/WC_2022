extends AudioStreamPlayer

@export_range(-80, 6, 0.1) var start_volume_db := -8.0

func _ready() -> void:
	if stream:
		stream.loop = true
	bus = "MusicIntro"
	if not playing:
		volume_db = start_volume_db
		play()
