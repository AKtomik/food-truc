class_name Order
extends Control

var resource: OrderResource
#var character: CharacterResource
var is_inspector: bool
var time_max: float
var time_remain: float

func setup(order_resource: OrderResource, inspection: bool = false, time_factor: int = 1):
	resource = order_resource
	time_max = order_resource.expiration_time * time_factor
	time_remain = time_max
	is_inspector = inspection

func given_happy(food: Item) -> bool:
	if (resource.good_food.is_scene(food)):
		return true
	if (!is_inspector && resource.bad_food.is_scene(food)):
		return true
	return false
	
