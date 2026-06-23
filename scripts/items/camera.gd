extends Item
class_name Camera

const CAMERA = preload("uid://b78hjh8211k6i")

@onready var shader_camera: SubViewport = $ShaderCamera
@onready var item_camera: Camera3D = $MainCamera/ItemCamera
@onready var area_3d: Area3D = $RemoteTransform3D/Area3D
@onready var animation_player: AnimationPlayer = $blockbench_export/AnimationPlayer
@onready var flash: SpotLight3D = $Flash

var taken_images: Array[TakenImage] = [];

func init(hand: Node3D) -> Item:
	var instance = CAMERA.instantiate()
	hand.add_child(instance)
	return instance  # geef de in-tree instance terug

func use() -> void:
	animation_player.play("shoot")
	await get_tree().create_timer(0.2).timeout
	_flash()
	var photographed = self.get_goals_in_objects(item_camera)
	
	await get_tree().process_frame
	var tyfus = TakenImage.create_image(photographed, shader_camera.get_texture().get_image())
	taken_images.append(tyfus)
	print("points: ", tyfus.total_points, ", objects: " , tyfus.objects_in_image)
	tyfus.save_image()

func _flash() -> void:
	flash.light_energy = 17.5;
	await get_tree().create_timer(0.1).timeout
	flash.light_energy = 0.0

func get_goals_in_objects(cam: Camera3D) -> Array[PhotographableObject]:
	var results: Array[PhotographableObject] = []
	
	var in_vision = area_3d.get_overlapping_bodies();
	
	for obj in in_vision:
		if obj.is_in_group(Groups.photographable):
			results.append(obj)
	
	return results;
