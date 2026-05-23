extends Node3D

@export var camera: Camera3D
@export var RAY_LENGTH: int = 1000
@export_flags_3d_physics var items_physics
@export_flags_3d_physics var slots_physics
@export_flags_3d_physics var tools_physics
@export_flags_3d_physics var planer_physics

var in_hand: Item = null

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if (in_hand):
		in_hand.position = self.position

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("take"):
		if (hand_taken()):
			print("must throw")
			return

		else:
			var space_state = get_world_3d().direct_space_state
			var mouse_position = get_viewport().get_mouse_position()
			
			var from_vector = camera.project_ray_origin(mouse_position)
			var to_vector = from_vector + camera.project_ray_normal(mouse_position) * RAY_LENGTH
			var query = PhysicsRayQueryParameters3D.create(from_vector, to_vector, items_physics)
			
			var result = space_state.intersect_ray(query)
			
			if (result.is_empty()):
				print("take empty")
				return
			
			var collider = result.get("collider") as Object
			print("take item:", collider)
			take_item(collider)

func hand_taken() -> bool:
	return in_hand != null

func take_item(target: Item) -> bool:
	target.reparent(self)
	in_hand = target
	return true
