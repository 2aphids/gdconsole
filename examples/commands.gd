extends Node


func print(args: Array) -> void:
	var result: String = ""
	for arg in args:
		result += arg + " "
	print(result)
