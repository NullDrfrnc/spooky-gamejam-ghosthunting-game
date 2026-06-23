extends CharacterBody3D
class_name Player

@onready var player_movement: PlayerMovement;
@onready var player_inventory: PlayerInventory;

const CAMERA = preload("uid://b78hjh8211k6i")

func _ready() -> void:
	player_movement = $PlayerMovement
	player_movement.camera = $PlayerCamera
	player_movement.player = self
	
	player_inventory = $PlayerInventory
	player_inventory.add_item(CAMERA.instantiate())
