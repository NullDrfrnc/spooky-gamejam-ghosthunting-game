extends Node3D
class_name PlayerInventory

@onready var hand: Node3D = $"../PlayerCamera/Hand"

@export var max_slots = 3;
@onready var _current_item_slot = 0;
@onready var _held_instance: Item = null

@onready var _inventory: Array[Item] = [];

@onready var _ui: Array[TextureRect] = [
	$"../PlayerCamera/CanvasLayer/HBoxContainer/Slot1", 
	$"../PlayerCamera/CanvasLayer/HBoxContainer/Slot2", 
	$"../PlayerCamera/CanvasLayer/HBoxContainer/Slot3"]

func _ready() -> void:
	_update_ui()
	_update_handheld_item()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inv_held_next"):
		_current_item_slot = (_current_item_slot + 1) % max_slots
		_update_ui()
		_update_handheld_item()
	
	elif event.is_action_pressed("inv_held_prev"):
		_current_item_slot = (_current_item_slot - 1 + max_slots) % max_slots
		_update_ui()
		_update_handheld_item()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inv_held_use"):
		if _held_instance != null:
			_held_instance.use()
	
	_update_ui()

func _update_handheld_item() -> void:
	for child in hand.get_children():
		child.queue_free()
	_held_instance = null
	
	var current_item = get_held_item()
	if current_item != null:
		_held_instance = current_item.init(hand)

func _update_ui() -> void:
	for i in _ui.size():
		var button = _ui[i]
		
		if i < _inventory.size():
			var item = _inventory.get(i)
			if (item != null):
				button.texture = item.texture;

func get_held_item() -> Item:
	if _current_item_slot < _inventory.size():
		return _inventory.get(_current_item_slot);
	return null;

func add_item(toAdd: Item) -> bool:
	if _check_inventory_full():
		return false;
	
	_inventory.append(toAdd);
	return true;

func remove_item(index: int) -> Item:
	return _inventory.pop_at(index);

func _check_inventory_full() -> bool:
	return _inventory.size() >= max_slots;
