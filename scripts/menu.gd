extends VBoxContainer


func populate(arr: Array[String], callable: Callable) -> void:
	clear()
	for i in arr:
		var button: ButtonCallable = ButtonCallable.new()
		button.signal_func = callable
		button.text = i
		button.button_down.connect(clear)
		self.add_child(button)


func clear() -> void:
	for child in get_children():
		child.queue_free()
