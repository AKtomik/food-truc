class_name FacePicker
extends Node

const face_bank: FaceBank = preload("res://resources/FaceBank.tres")

static var culinary_critique_texture: Texture2D = null
static var culinary_critique_color: Color

func setup() -> void:
	culinary_critique_texture = face_bank.faces.pick_random()
	culinary_critique_color = CharResourcesSpawner.random_skin_color()

func apply_critique_texture(face_mesh : MeshInstance3D) -> void:
	_apply_texture(culinary_critique_texture, face_mesh)

func apply_random_texture(face_mesh : MeshInstance3D) -> void :
	var texture: Texture2D = face_bank.faces.pick_random()
	while texture == culinary_critique_texture :
		face_bank.faces.pick_random()
	_apply_texture(texture, face_mesh)

func _apply_texture(texture: Texture2D, face_mesh : MeshInstance3D) -> void:
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = texture
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	face_mesh.material_override = mat
