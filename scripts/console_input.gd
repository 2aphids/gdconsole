extends LineEdit

var current_suggestions: Array = []
var _suggestion_index := 0


func _input(_event: InputEvent) -> void:
	if !has_focus():
		return

	if current_suggestions.size() > 0:
		if Input.is_action_just_pressed("ui_text_completion_accept", false):
			text = current_suggestions[_suggestion_index]
			_suggestion_index -= 1
			if(_suggestion_index < 0):
				_suggestion_index = current_suggestions.size()-1
