extends Node
class_name TakenImage

var objects_in_image: Array[PhotographableObject] = []
var total_points: float = 0
var image: Image

static func create_image(objects: Array[PhotographableObject], img: Image) -> TakenImage: 
	var taken_image = TakenImage.new()
	
	for obj in objects:
		taken_image.total_points += obj.points
		taken_image.objects_in_image.append(obj)
		taken_image.image = img
	
	return taken_image

func save_image() -> void:
	var picture_dir = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES)
	var spooky_dir = picture_dir.path_join("spooky")
	
	DirAccess.make_dir_recursive_absolute(spooky_dir)
	
	var filename = spooky_dir.path_join("photo_%d.png" % Time.get_unix_time_from_system())
	image.save_png(filename);
