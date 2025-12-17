extends BoxContainer

func _init() -> void:
	self.replace_by(preload("scenes/console.tscn").instantiate())
