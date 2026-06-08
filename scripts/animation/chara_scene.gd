class_name CharacterBody
extends Node3D

@export var anime : AnimationPlayer
var order_resource : OrderResource
var face_picker : FacePicker
var arrived : bool = false


func _ready() -> void:
	pass
	#anime.play("Arrive")

func play_arrive():
	anime.play("Arrive")
	arrived = true

func play_quit():
	if (arrived):
		anime.play("Go")
	else:
		anime.play("Behind")
	# body is killed in the end of the action either way

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_face_texture() -> Texture2D:
	return (self.get_node("SM_chara_base").material_override as StandardMaterial3D).albedo_texture

func is_culinary() -> bool:
	return get_face_texture() == face_picker.culinary_critique_texture
	
