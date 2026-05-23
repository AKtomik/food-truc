class_name Item
extends Node3D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass


func place_center():
	position = Vector3(0, 0, 0)

func place_at(place: Node3D):
	global_position = place.global_position

# TODO
func place_at_progress(place: Node3D, time: float):
	place_at(place)