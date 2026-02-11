extends Node

# this file should be placed in your project and set to be a singleton named Commands

func print(args: Array) -> void:
	var result: String = ""
	for arg in args:
		result += arg + " "
	print(result)
