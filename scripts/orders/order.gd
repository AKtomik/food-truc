class_name Order
extends Control

var resource: OrderResource
var character_body: Node3D
var is_inspector: bool
var time_max: float
var time_remain: float
var number: int

@export var ui_image: TextureRect
@export var ui_label: Label
@export var progress_bar: ProgressBar

# init
func setup(order_resource: OrderResource, character: CharacterBody, inspection: bool = false, time_scale: float = 1):
	resource = order_resource
	character_body = character
	time_max = order_resource.expiration_time * time_scale
	time_remain = time_max
	is_inspector = inspection
	number = randi() % 10000

	ui_image.texture = order_resource.kaway_image
	ui_label.text = "commande #"+str(number)

# loop
func _process(delta: float) -> void:
	progress_bar.max_value = time_max
	progress_bar.value = time_remain

# ask
func given_happy(food: Item) -> bool:
	if (resource.good_food.is_scene(food)):
		return true
	if (!is_inspector && resource.bad_food.is_scene(food)):
		return true
	return false
