class_name Hand
extends Node3D

@export var camera: Camera3D
@export var offset: Vector3 = Vector3(0, 0, 0)

@export_category("raycast")
@export var RAY_LENGTH: int = 1000
@export_flags_3d_physics var slots_physics
@export_flags_3d_physics var tools_physics
@export_flags_3d_physics var cat_physics

var in_hand: Item = null
var _can_click: bool = true

func _ready() -> void:
	pass

func set_enable_click(state: bool) -> void:
	_can_click = state

func _process(_delta: float) -> void:
	self.global_position = ray_cat() + offset

func _physics_process(_delta: float) -> void:
	if (!_can_click): return
	if Input.is_action_just_pressed("take"):
		if (full()):
			print("try throw")
			
			var tool = ray_tool()
			if (tool):
				if (!tool.can_put(in_hand)):
					print("full tool:", tool)
					return
				print("tool throw")
				put_tool(tool)
				return

			var slot = ray_slot()
			if (!slot):
				print("no throw")
				return
			if (slot.full()):
				print("full slot:", slot)
				return

			print("take slot:", slot)
			put_slot(slot)

		else:
			print("try take")
			
			var tool = ray_tool()
			if (tool && tool.can_take(in_hand)):
				if (!tool.can_take(in_hand)):
					print("full tool:", tool)
					return
				print("tool take")
				take_tool(tool)
				return

			var slot = ray_slot()
			if (!slot):
				print("no take")
				return
			if (!slot.full()):
				print("empty slot:", slot)
				return

			print("take slot:", slot)
			take_slot(slot)

func ray_cat() -> Vector3:
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	
	var from_vector = camera.project_ray_origin(mouse_position)
	var to_vector = from_vector + camera.project_ray_normal(mouse_position) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(from_vector, to_vector, cat_physics)
	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	if (result.is_empty()): return Vector3()
	return result.get("position")

func ray_slot() -> ItemSlot:
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	
	var from_vector = camera.project_ray_origin(mouse_position)
	var to_vector = from_vector + camera.project_ray_normal(mouse_position) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(from_vector, to_vector, slots_physics)
	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	if (result.is_empty()): return null
	return result.get("collider") as ItemSlot

func ray_tool() -> ItemTool:
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	
	var from_vector = camera.project_ray_origin(mouse_position)
	var to_vector = from_vector + camera.project_ray_normal(mouse_position) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(from_vector, to_vector, tools_physics)
	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	if (result.is_empty()): return null
	return result.get("collider") as ItemTool

func full() -> bool:
	return in_hand != null

func take_slot(slot: ItemSlot):
	var item = slot.take_item()
	item.reparent(self)
	item.place_center()
	in_hand = item
	
func put_slot(slot: ItemSlot):
	slot.put_item(in_hand)
	in_hand = null

func take_tool(tool: ItemTool):
	var item = tool.take()
	item.reparent(self)
	item.place_center()
	in_hand = item
	
func put_tool(tool: ItemTool):
	var throw = tool.put(in_hand)
	if (throw):
		in_hand = null

func switch_hand_to(item_resource: ItemResource):
	if (in_hand):
		in_hand.queue_free()
		in_hand = null
	var new_item = item_resource.model_scene.instantiate()
	add_child(new_item)
	in_hand = new_item
