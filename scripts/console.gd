class_name Console extends BoxContainer

@export var max_lines := 16
@export var line_timeout := 5.0

@onready var output: VBoxContainer = $Output
@onready var line_edit: LineEdit = $Input/LineEdit

# const SCENE_DIR := "scenes/maps/"


# func _cmd_prop(args: Array) -> void:
# 	if (args == [] or !get_node("/root/Main/World")):
# 		return
#
# 	print("Spawning prop `%s`" % args[0])
#
# 	var world: Node3D = get_node("/root/Main/World")
# 	var res := load("res://models/gltf/props/%s.glb" % args[0])
# 	if (res):
# 		var prop: PhysicsProp = res.instantiate()
# 		prop.global_position = Variables.player.find_child("HeldItemPoint", true, false).global_position
# 		world.add_child(prop)


# func _process(delta: float) -> void:
# 	print(get_children().size())


func _cmd_print(args: Array) -> void:
	var result: String = ""
	for arg in args:
		result += arg + " "
	print(result)


# func _cmd_map(args: Array) -> void:
# 	if (args == []):
# 		print("Available maps:")
# 		var dir = DirAccess.open(SCENE_DIR)
# 		assert(dir, "Scene directory invalid")
# 		dir.list_dir_begin()
# 		var file_name = dir.get_next()
# 		while file_name != "":
# 			if dir.current_is_dir():
# 				print("> " + file_name)
# 			file_name = dir.get_next()
# 		return
# 	get_node("/root/Main").load_map(SCENE_DIR + args[0] + ".tscn")


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
	var cmd = Callable(self, "_cmd_" + cmds[0])

	if (cmd.is_valid()):
		cmd.call(cmds.slice(1, cmds.size()))
	# elif (Variables.get(cmds[0]) != null):
	# 	var args = cmds.slice(0, cmds.size())
	# 	if (args.size() < 1):
	# 		return
	# 	elif (args.size() > 1):
	# 		var t = typeof(Variables.get(args[0]))
	# 		match t:
	# 			TYPE_STRING:
	# 				Variables.set(args[0], args[1])
	# 			TYPE_BOOL:
	# 				Variables.set(args[0], true if args[1] == "true" else false)
	# 			TYPE_INT:
	# 				Variables.set(args[0], args[1].to_int())
	# 			TYPE_FLOAT:
	# 				Variables.set(args[0], args[1].to_float())
	# 	if Variables.MAN.has(str(args[0])):
	# 		print(Variables.MAN[str(args[0])])
	# 	print(str(args[0]) + " = " + str(Variables.get(args[0])))
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

	# for prop in Variables.get_property_list():
	# 	if (prop['name'].begins_with(line_edit.text)):
	# 		var label: Label = Label.new()
	# 		label.text = prop['name']
	# 		line_edit.current_suggestions.push_back(prop['name'])
	# 		$Input.add_child(label)
