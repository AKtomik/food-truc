class_name Microwave
extends ItemTool

@export var recipe_in: ItemResource
@export var recipe_out: ItemResource
@export var cooking_time: int

var items_inside: Array[Item] = []
var running: bool = false

func can_put(item: Item) -> bool:
	return !running && recipe_in.is_scene(item)

func can_take(_item: Item) -> bool:
	return !running && !items_inside.is_empty()

func put(item: Item) -> bool:
	item.reparent(self)
	item.place_center()
	items_inside.append(item)
	if true:
		start_cooking()
	return true

func start_cooking():
	# start
	running = true

	# clear
	for item in items_inside:
		item.queue_free()
	items_inside = []

	# wait
	print("start microwave...")
	await get_tree().create_timer(cooking_time).timeout
	finish_cooking()

func finish_cooking():
	# finish
	print("finish microwave")

	# fill
	var item = recipe_out.model_scene.instantiate()
	add_child(item)
	items_inside.append(item)
	running = false


func take() -> Item:
	return items_inside.pop_front()
