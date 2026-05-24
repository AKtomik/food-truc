extends Resource
class_name SimpleRecipeResource

@export var ingredient: ItemResource
@export var result: ItemResource
@export var cooking_time: float

func is_ingredient(item: Item) -> bool:
	return ingredient.is_scene(item)
