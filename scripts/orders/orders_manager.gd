class_name OrdersManager
extends Node

@export var star_manager: StarManager
@export var face_picker : FacePicker
@export var money_manager: CashMachine
@export var order_resources: Array[OrderResource]
@export var order_container: Control
@export var packed_order: PackedScene

@export var order_wait_time: float = 20
@export var order_never_empty: bool = true

@export var FAIL_NORMAL_UNSTAR: float = .25
@export var FAIL_INSPECTOR_UNSTAR: float = 1

# store
var order_list: Array[Order] = []
var next_order: float = -1

func last_order() -> Order:
	if (order_list.is_empty()): return null
	return order_list[0]

# loop
func _ready() -> void:
	new_order(order_resources.pick_random())
	next_order = order_wait_time * 2

func _process(delta: float) -> void:
	# expiration
	var expired_order = []
	for order in order_list:
		order.time_remain -= delta
		if (order.time_remain <= 0):
			expired_order.append(order)
	for order in expired_order:
		fail_order(order)
		remove_order(order)
	
	# creation
	next_order -= delta
	if (next_order < 0 || order_never_empty && order_list.is_empty()):
		new_order(order_resources.pick_random())
		next_order = order_wait_time
	

# create
func new_order(new_order_resource: OrderResource) -> void:
	print("add a new order!", new_order_resource)
	var new_order_instance = packed_order.instantiate() as Order
	new_order_instance.setup(new_order_resource)

	order_container.add_child(new_order_instance)
	order_container.move_child(new_order_instance, 0)
	order_list.append(new_order_instance)

# finish
func given_food(item: Item) -> void:
	print("given food to first order:", item)
	var order = last_order()
	var happy = order.given_happy(item)
	if (happy):
		successful_order(order)
	else:
		fail_order(order)
	remove_order(order)

func successful_order(order: Order) -> void:
	print("successful order:", order)
	money_manager.pay(order.resource.price)

func fail_order(order: Order) -> void:
	print("fail order:", order)
	var tige = FAIL_INSPECTOR_UNSTAR if (order.is_inspector) else FAIL_NORMAL_UNSTAR
	star_manager.remove_star(tige)

func remove_order(order: Order) -> void:
	order_list.remove_at(order_list.find(order))
	order.queue_free()
