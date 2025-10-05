class_name TimeHelper

static func get_time_text(time_left: int) -> String:
	if time_left < 0:
		return "Overtime"
	else: 
		# var minutes := int(time_left / 60) 
		# var seconds := time_left - minutes * 60
		var ret_str: String = "%02d:%02d" % [time_left / 60, time_left % 60]
		print("Time" + ret_str)
		return ret_str
