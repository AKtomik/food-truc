class_name Microwave
extends ItemTool

@export var recipes: Array[MicrowaveRecipeResource]

@onready var open_node: Node3D = $%MeshOpen
@onready var close_node: Node3D = $%MeshClose
@onready var audio_player: AudioStreamPlayer = $MicroWaveAudio

var items_inside: Array[Item] = []
var closed: bool = false

var audio_ding: AudioStream = preload("res://assets/mircowave_ding.mp3")

# Loop
func ready():
	open()

# Recipes
func find_recipe(items: Array[Item]) -> MicrowaveRecipeResource:
	for recipe in recipes:
		if (recipe.is_valid_ingredients(items)):
			return recipe
	return null

# Item Tool
func can_put(item: Item) -> bool:
	var potential_items = items_inside.duplicate()
	potential_items.push_back(item)
	return !closed && find_recipe(potential_items) != null

func can_take(_item: Item) -> bool:
	return !closed && !items_inside.is_empty()

func put(item: Item) -> bool:
	item.reparent(self)
	item.place_center()
	items_inside.append(item)
	var recipe = find_recipe(items_inside)
	if (!recipe): push_error("put() but no recipe for items_inside:", items_inside)
	if recipe.is_full_ingredients(items_inside):
		process_cooking(recipe)
	return true

func take() -> Item:
	return items_inside.pop_front()

# State
func open():
	open_node.visible = true
	close_node.visible = false
	closed = false

func close():
	open_node.visible = false
	close_node.visible = true
	closed = true

# Cook
func process_cooking(recipe: MicrowaveRecipeResource):
	start_cooking(recipe)
	await get_tree().create_timer(recipe.cooking_time).timeout
	finish_cooking(recipe)

func start_cooking(recipe: MicrowaveRecipeResource):
	# start
	print("start microwave...", recipe)
	close()

	# clear
	for item in items_inside:
		item.queue_free()
	items_inside = []

func finish_cooking(recipe: MicrowaveRecipeResource):
	# finish
	print("finish microwave", recipe)
	audio_player.stream = audio_ding
	audio_player.play()
	open()

	# fill
	var item = recipe.result.model_scene.instantiate()
	add_child(item)
	items_inside.push_back(item)
