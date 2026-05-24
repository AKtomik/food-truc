extends Resource
class_name MicrowaveRecipeResource

@export var ingredients: Array[ItemResource]
@export var result: ItemResource
@export var cooking_time: float

func _contains_ingredient(item: Item) -> bool:
	for ingredient in ingredients:
		if ingredient.is_scene(item):
			return true
	return false

func is_valid_ingredients(items: Array[Item]) -> bool:
	for item in items:
		if (!_contains_ingredient(item)): return false
	return true
	
func is_full_ingredients(items: Array[Item]) -> bool:
	return items.size() == ingredients.size() && is_valid_ingredients(items)
