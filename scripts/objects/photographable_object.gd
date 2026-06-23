extends StaticBody3D
class_name PhotographableObject

@export var points: float = 0

func _ready() -> void:
	self.add_to_group(Groups.photographable)
