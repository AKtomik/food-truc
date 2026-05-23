extends Resource
class_name ItemResource

@export var model_scene: PackedScene

func is_scene(item: Item) -> bool:
	return item.scene_file_path == model_scene.resource_path
