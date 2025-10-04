extends Control

func _ready() -> void:
	$VBoxContainer/master.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$VBoxContainer/background.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$VBoxContainer/intro.value = db_to_linear(AudioServer.get_bus_volume_db(2))

func _on_background_mouse_exited() -> void:
	release_focus()

func _on_master_mouse_exited() -> void:
	release_focus()
