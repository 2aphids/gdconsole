class_name Console extends BoxContainer

@export var max_lines := 16
@export var line_timeout := 5.0

@onready var output: VBoxContainer = $Output
@onready var line_edit: LineEdit = $Input/LineEdit


# stupid hack
func _process(delta: float) -> void:
	size = get_viewport_rect().size
	position = Vector2()


func toggle() -> void:
	line_edit.visible = !line_edit.visible
	if (line_edit.visible):
		line_edit.grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func close() -> void:
	line_edit.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _ready() -> void:
	ConsoleLogger.log.console = self
	line_edit.text_changed.connect(Callable(self, "_text_changed"))


func _input(_event) -> void:
	if Input.is_action_just_pressed("console", false):
		toggle()

	if (!line_edit.visible):
		return

	if Input.is_action_just_pressed("ui_cancel", false):
		close()

	if Input.is_action_just_pressed("ui_text_submit", false):
		_submit()


func _submit() -> void:
	var cmds: PackedStringArray = line_edit.text.split(" ", false)
	var cmd = Callable(Commands, cmds[0])

	if (cmd.is_valid()):
		cmd.call(cmds.slice(1, cmds.size()))
	elif (Variables.get(cmds[0]) != null):
		var args = cmds.slice(0, cmds.size())
		var t = typeof(Variables.get(args[0]))
		if (args.size() > 1):
			match t:
				TYPE_STRING:
					Variables.set(args[0], args[1])
				TYPE_BOOL:
					Variables.set(args[0], true if args[1] == "true" else false)
				TYPE_INT:
					Variables.set(args[0], args[1].to_int())
				TYPE_FLOAT:
					Variables.set(args[0], args[1].to_float())
		elif (t == TYPE_BOOL):
			Variables.set(args[0], !Variables.get(args[0]))
		if Variables.MAN.has(str(args[0])):
			print(Variables.MAN[str(args[0])])
		print(str(args[0]) + " = " + str(Variables.get(args[0])))
	else:
		print("Command or variable '" + cmds[0] + "' does not exist.")

	line_edit.clear()
	close()


func _text_changed(_new_text: String) -> void:
	var c: int = line_edit.caret_column # .replacen() resets caret; we dont want that to happen
	line_edit.text = line_edit.text.replacen("`", "") # remove dev keybind char
	line_edit.caret_column = c

	for n in $Input.get_children():
		if n == line_edit:
			continue
		n.queue_free()

	line_edit.current_suggestions = []

	if (line_edit.text.length() == 0):
		return

	for prop in Variables.get_property_list():
		if (prop['name'].begins_with(line_edit.text)):
			var label: Label = Label.new()
			label.text = prop['name']
			line_edit.current_suggestions.push_back(prop['name'])
			$Input.add_child(label)
