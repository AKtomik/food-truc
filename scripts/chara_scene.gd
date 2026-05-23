extends Node3D

@export var visage : Material

@onready var anime : AnimationPlayer = %Arrive
@onready var hat = $SM_chara_base/Hat
@onready var hair = $SM_chara_base/Hair
@onready var eyes = $SM_chara_base/Eyes
@onready var mouth = $SM_chara_base/Mouth
@onready var neck = $SM_chara_base/Neck
@onready var jacket = $SM_chara_base/Jacket


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anime.play("Arrive")
	#await anime.animation_finished
	#anime.play("Go")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
