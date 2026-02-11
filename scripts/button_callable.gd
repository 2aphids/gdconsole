class_name ButtonCallable extends Button


var signal_func: Callable


func _ready() -> void:
	self.button_down.connect(_on_button_down)


func _on_button_down() -> void:
	signal_func.call(text)
