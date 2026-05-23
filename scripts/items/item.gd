class_name Item
extends Node3D

#@export var linked_resource : ItemResource# no

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass


func place_center():
	scale = Vector3(1, 1, 1)
	position = Vector3(0, 0, 0)

func place_at(place: Node3D):
	scale = Vector3(1, 1, 1)
	global_position = place.global_position

# TODO
func place_at_progress(place: Node3D, time: float):
	place_at(place)
