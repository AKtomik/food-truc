class_name Queue

var _items: Array = []

func enqueue(item) -> void:
	_items.push_back(item)

func dequeue():
	if is_empty():
		push_warning("Queue is empty")
		return null
	return _items.pop_front()

func peek():
	if is_empty():
		return null
	return _items[0]

func is_empty() -> bool:
	return _items.size() == 0

func size() -> int:
	return _items.size()

func clear() -> void:
	_items.clear()
