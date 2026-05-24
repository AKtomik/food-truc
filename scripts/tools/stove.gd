class_name Stove
extends ItemTool


@export var audio_player: AudioStreamPlayer

var audio_steak : AudioStream = preload("res://assets/sounds/cooking_steak.mp3")

@export var recipes: Array[SimpleRecipeResource]

var item_inside: Item = null
var closed: bool = false

# Loop
func ready():
	#audio_player.stream.loop = true
	open()

# Recipes
func find_recipe(item: Item) -> SimpleRecipeResource:
	for recipe in recipes:
		if (recipe.is_ingredient(item)):
			return recipe
	return null

# Item Tool
func can_put(item: Item) -> bool:
	return !closed && !item_inside && find_recipe(item) != null

func can_take(_item: Item) -> bool:
	return !closed && item_inside

func put(item: Item) -> bool:
	item.reparent(self)
	item.place_center()
	item_inside = (item)
	var recipe = find_recipe(item)
	if (!recipe): push_error("put() but no recipe for item:", item)
	audio_player.stream = audio_steak
	audio_player.stream.loop = true
	#print(audio_player.stream)
	audio_player.play()
	process_cooking(recipe)
	return true

func take() -> Item:
	var item = item_inside
	item_inside = null
	return item

# State
func open():
	closed = false

func close():
	closed = true

# Cook
func process_cooking(recipe: SimpleRecipeResource):
	start_cooking(recipe)
	await get_tree().create_timer(recipe.cooking_time).timeout
	finish_cooking(recipe)

func start_cooking(recipe: SimpleRecipeResource):
	# start
	print("start stove...", recipe)
	close()


func finish_cooking(recipe: SimpleRecipeResource):
	# clear
	item_inside.queue_free()
	item_inside = null

	# finish
	print("finish stove", recipe)
	audio_player.stop()
	open()

	# fill
	var item = recipe.result.model_scene.instantiate()
	add_child(item)
	item_inside = item
