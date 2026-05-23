class_name CharResourcesSpawner
extends Node

const CHARACTER_SCENE = preload("res://scenes/CharaScene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

static func spawn(def: CharacterResource, parent: Node3D) -> Node3D:
	var characterScene = CHARACTER_SCENE.instantiate()
	parent.add_child(characterScene)

	var character = characterScene.get_node("SM_chara_base")
	character.get_node("Hat").mesh = def.hat_mesh
	character.get_node("Hair").mesh = def.hair_mesh
	character.get_node("Eyes").mesh = def.eyes_mesh
	character.get_node("Mouth").mesh = def.mouth_mesh
	character.get_node("Neck").mesh = def.neck_mesh
	character.get_node("Jacket").mesh = def.jacket_mesh

	var mat = StandardMaterial3D.new()
	mat.albedo_color = def.color_override
	return character
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
