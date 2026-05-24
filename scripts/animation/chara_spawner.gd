class_name CharResourcesSpawner
extends Node

const CHARACTER_SCENE = preload("res://scenes/CharaScene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

static func spawn(def: CharacterResource, parent: Node3D, critique : bool,
	face_picker : FacePicker, order_resource : OrderResource) -> CharacterBody:

	var characterScene = CHARACTER_SCENE.instantiate()
	characterScene.face_picker = face_picker
	characterScene.order_resource = order_resource
	parent.add_child(characterScene)

	var character = characterScene.get_node("SM_chara_base")
	character.get_node("Hat").mesh = def.hat_mesh
	character.get_node("Hair").mesh = def.hair_mesh
	character.get_node("Eyes").mesh = def.eyes_mesh
	character.get_node("Mouth").mesh = def.mouth_mesh
	character.get_node("Neck").mesh = def.neck_mesh
	character.get_node("Jacket").mesh = def.jacket_mesh
	character.get_node("FaceHair").mesh = def.face_hair_mesh
	_apply_color(character, critique, face_picker)
	
	var chara_mesh : MeshInstance3D = character.get_node("Face")
	if (critique) :
		face_picker.apply_critique_texture(chara_mesh)
	else :
		face_picker.apply_random_texture(chara_mesh)
	return characterScene
		
static func _apply_color(character: Node3D, critique : bool, face_picker : FacePicker) -> void:
	for node in character.find_children("*", "MeshInstance3D"):
		if not node.visible:
			continue
		var mat = StandardMaterial3D.new()
		if  node.name == "SM_chara_base" :
			if (critique) :
				mat.albedo_color = face_picker.culinary_critique_color
			else :
				mat.albedo_color = random_skin_color()
		elif node.name == "Hat" or node.name == "Jacket" or node.name == "Neck" :
			mat.albedo_color = random_clothing_color()
		elif node.name == "Hair" or node.name == "Eyes" or node.name == "FaceHair" :
			mat.albedo_color = random_hair_color()
		node.material_override = mat

static func random_clothing_color() -> Color:
	return Color.from_hsv(randf(), randf_range(0.1, 0.4), randf_range(0.3, 0.8))

static func random_skin_color() -> Color:
	return Color.from_hsv(randf_range(0.03, 0.1), randf_range(0.2, 0.6), randf_range(0.3, 0.95))

static func random_hair_color() -> Color:
	var roll = randf()
	if roll < 0.6:
	# Brun / noir
		return Color.from_hsv(randf_range(0.05, 0.1), randf_range(0.3, 0.6), randf_range(0.05, 0.4))
	elif roll < 0.8:
		# Blond
		return Color.from_hsv(randf_range(0.08, 0.13), randf_range(0.3, 0.6), randf_range(0.6, 0.95))
	elif roll < 0.93:
		# Roux
		return Color.from_hsv(randf_range(0.03, 0.07), randf_range(0.5, 0.8), randf_range(0.4, 0.7))
	else:
		# Coloré (bleu, violet, rose...)
		return Color.from_hsv(randf_range(0.5, 0.9), randf_range(0.5, 0.9), randf_range(0.5, 0.9))
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
