extends Node3D

@onready var anime : AnimationPlayer = %Arrive
var face_picker : FacePicker

func _ready() -> void:
	anime.play("Arrive")
	#await anime.animation_finished
	#anime.play("Go")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_face_texture() -> Texture2D :
	return (self.get_node("SM_chara_base").material_override as StandardMaterial3D).albedo_texture

func is_culinary() -> bool:
	return get_face_texture() == face_picker.culinary_critique_texture
	
