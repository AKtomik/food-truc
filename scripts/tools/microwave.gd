class_name Microwave
extends ItemTool

@export var recipes: Array[MicrowaveRecipeResource]

var items_inside: Array[Item] = []
var running: bool = false

# recipes
func find_recipe(items: Array[Item]) -> MicrowaveRecipeResource:
	for recipe in recipes:
		if (recipe.is_valid_ingredients(items)):
			return recipe
	return null

# ItemTool
func can_put(item: Item) -> bool:
	var potential_items = items_inside.duplicate()
	potential_items.push_back(item)
	return !running && find_recipe(potential_items) != null

func can_take(_item: Item) -> bool:
	return !running && !items_inside.is_empty()

func put(item: Item) -> bool:
	item.reparent(self)
	item.place_center()
	items_inside.append(item)
	if true:
		process_cooking()
	return true

func take() -> Item:
	return items_inside.pop_front()

# Cook
func process_cooking():
	var recipe = find_recipe(items_inside)
	if (!recipe): push_error("process_cooking() but no recipe for items_inside:", items_inside)
	start_cooking(recipe)
	await get_tree().create_timer(recipe.cooking_time).timeout
	finish_cooking(recipe)

func start_cooking(recipe: MicrowaveRecipeResource):
	# start
	print("start microwave...", recipe)
	running = true

	# clear
	for item in items_inside:
		item.queue_free()
	items_inside = []

func finish_cooking(recipe: MicrowaveRecipeResource):
	# finish
	print("finish microwave", recipe)
	running = false

	# fill
	var item = recipe.result.model_scene.instantiate()
	add_child(item)
	items_inside.append(item)
