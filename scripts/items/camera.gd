extends Item
class_name Camera
const CAMERA = preload("uid://b78hjh8211k6i")

@onready var shader_camera: SubViewport = $ShaderCamera
@onready var item_camera: Camera3D = $MainCamera/ItemCamera
@onready var area_3d: Area3D = $MainCamera/ItemCamera/Area3D

func init(hand: Node3D) -> Item:
	var instance = CAMERA.instantiate()
	hand.add_child(instance)
	return instance  # geef de in-tree instance terug

func use() -> void:
	var photographed = self.get_goals_in_objects(item_camera)
	
	print("Op de foto: ", photographed)
	
	await get_tree().process_frame
	var image = shader_camera.get_texture().get_image()
	
	var picture_dir = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES)
	var spooky_dir = picture_dir.path_join("spooky")
	
	DirAccess.make_dir_recursive_absolute(spooky_dir)
	
	var filename = spooky_dir.path_join("photo_%d.png" % Time.get_unix_time_from_system())
	image.save_png(filename);

func get_goals_in_objects(cam: Camera3D) -> Array[PhotographableObject]:
	var results: Array[PhotographableObject] = []
	
	var in_vision = area_3d.get_overlapping_bodies();
	
	print(in_vision)
	
	for obj in in_vision:
		if obj.is_in_group(Groups.photographable):
			results.append(obj)
	
	return results;
