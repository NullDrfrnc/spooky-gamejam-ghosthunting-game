extends Node3D
class_name Item

@export var texture: Texture2D;

func use() -> void:
	print("item used!")

func init(hand: Node3D) -> Item:
	return self  # default: niks bijzonders te instantiëren
