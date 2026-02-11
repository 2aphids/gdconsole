@tool
extends EditorPlugin


func _enable_plugin():
	add_autoload_singleton("ConsoleLogger", "res://addons/gdconsole/scripts/logger.gd")
	add_custom_type("DropdownMenu", "VBoxContainer", preload("scripts/menu.gd"), null)


func _disable_plugin():
	remove_autoload_singleton("ConsoleLogger")
	remove_custom_type("DropdownMenu")
