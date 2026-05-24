extends MeshInstance3D

@export var subviewport: SubViewport
@export var viewportquad: MeshInstance3D = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#subviewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	#await get_tree().process_frame
	#await get_tree().process_frame
	viewportquad.material_override.albedo_texture = subviewport.get_texture()
