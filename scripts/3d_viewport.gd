extends MeshInstance3D

@export var subviewport: SubViewport
@export var viewportquad: MeshInstance3D = self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#subviewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	subviewport.set_clear_mode(SubViewport.CLEAR_MODE_ALWAYS)# for web
	await RenderingServer.frame_post_draw
	await get_tree().process_frame
	await get_tree().process_frame    
	var mat = viewportquad.material_override.duplicate()
	mat.albedo_texture = subviewport.get_texture()
	viewportquad.material_override = mat
