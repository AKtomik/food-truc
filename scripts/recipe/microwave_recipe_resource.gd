extends Resource
class_name MicrowaveRecipeResource

@export var ingredients: Array[ItemResource]
@export var result: ItemResource
@export var cooking_time: float

func is_valid_ingredients(items: Array[Item]) -> bool:
	var leftovers = ingredients.duplicate()

	for item in items:

		var valid = false
		for i in range(leftovers.size()):
			if leftovers[i].is_scene(item):
				valid = true
				leftovers.remove_at(i)
				break
		if (valid == false): return false

	return true
	
func is_full_ingredients(items: Array[Item]) -> bool:
	return items.size() == ingredients.size() && is_valid_ingredients(items)
