extends Node


class Log extends Logger:
	var index := 1 # skip first 2 children: $Input & $Output
	var console: Console = null

	func _spawn_label(msg: String):
		if (!console):
			return
		var label: Label = Label.new()
		# label.text = msg.replacen("\n\n", "")
		label.text = msg.strip_edges()
		label.theme = load("res://addons/gdconsole/theme/theme_command_palette.tres")
		label.autowrap_mode = 2

		if (console.output.get_children().size() > console.max_lines + 1):
			console.output.get_child(index).replace_by(label)
			index += 1
			if (index > console.max_lines + 1):
				index = 1
		else:
			console.output.add_child(label)

		await console.get_tree().create_timer(console.line_timeout).timeout
		label.queue_free()


	func _log_message(msg: String, err: bool) -> void:
		# if (err):
		# 	msg = "[color=red]ERROR: " + msg + "[/color]"
		_spawn_label(msg)


	func _log_error(
		_function: String,
		file: String,
		line: int,
		code: String,
		_rationale: String,
		_editor_notify: bool,
		error_type: int,
		_script_backtraces: Array[ScriptBacktrace]
	) -> void:
		# var text = "[color="
		# match error_type:
		# 	ERROR_TYPE_ERROR:
		# 		text += "red]ERROR: "
		# 	ERROR_TYPE_WARNING:
		# 		text += "orange]WARNING: "
		# 	ERROR_TYPE_SCRIPT:
		# 		text += "purple]SCRIPT ERROR: "

		# _spawn_label((text + code + "[/color]\n> L%d, " + file) % line + "\n")
		_spawn_label((code + "> L%d, " + file) % line + "\n")


var log := Log.new();

func _init() -> void:
	OS.add_logger(log)
