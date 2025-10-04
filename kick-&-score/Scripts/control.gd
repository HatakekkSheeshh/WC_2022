extends Control
class_name OptionsPanel

signal request_close
@onready var btn_back: Button = $back  

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	process_mode = Node.PROCESS_MODE_INHERIT
	anchors_preset = PRESET_FULL_RECT

	if btn_back:
		btn_back.pressed.connect(_close)

func _unhandled_input(e: InputEvent) -> void:
	if e.is_action_pressed("ui_cancel"):   # ESC/B
		_close()

func open() -> void:          
	show()
	grab_focus()

func _close() -> void:
	hide()                     
	request_close.emit()

func _on_confirm_pressed() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db($AudioOptions/VBoxContainer/master.value))
	AudioServer.set_bus_volume_db(1, linear_to_db($AudioOptions/VBoxContainer/background.value))
	AudioServer.set_bus_volume_db(2, linear_to_db($AudioOptions/VBoxContainer/intro.value))
