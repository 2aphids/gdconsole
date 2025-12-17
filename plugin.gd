@tool
extends EditorPlugin

const AUTOLOAD_NAME = "ConsoleLogger"


func _enable_plugin():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/gdconsole/scripts/logger.gd")


func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_NAME)
