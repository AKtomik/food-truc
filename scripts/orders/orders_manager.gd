class_name OrdersManager
extends Node

@export var flow_enabled: bool = true
@export var imediate_order: bool = true

@export_category("pointers")
@export var star_manager: StarManager
@export var character_queue: CharacterQueue
@export var face_picker: FacePicker
@export var money_manager: CashMachine
@export var packed_order: PackedScene
@export var ticket_container: Control

@export_category("resources")
@export var inital_resources: Array[OrderResource]
@export var unlock_turn_resources: Dictionary[int, OrderResource]

@export_category("orders")
@export var ORDER_REFILL_EMPTY: bool = true
@export var ORDER_REFILL_DELAY_MIN: float = 1
@export var ORDER_REFILL_DELAY_MAX: float = 2
@export var ORDER_GENERATE_DELAY_MIN: float = 10 # inclusive
@export var ORDER_GENERATE_DELAY_MAX: float = 20 # inclusive
@export var ORDER_FIRST_DELAY: float = 0
@export var ORDER_GENERATE_MAX_QUEUE: int = 5
#@export var ORDER_DISPLAY_MAX: int = 5

@export_category("speed")
@export var STARTING_SPEED: float = 0
@export var SPEED_STRENGTH: float = 50# 1000 is x2, 2000 is x3...
@export var SPEED_UP_SUCCESS: float = 1
@export var SLOW_DOWN_FAILURE: float = 5

@export_category("inspection")
@export var INSPECTION_TURN_DELAY_MIN: int = 2 # inclusive
@export var INSPECTION_TURN_DELAY_MAX: int = 9 # inclusive
@export var INSPECTION_FIRST_DELAY: int = 3

@export_category("stars")
@export var FAIL_NORMAL_UNSTAR: float = .25
@export var FAIL_INSPECTOR_UNSTAR: float = 1

@export_category("sounds")
@export var audio_player : AudioStreamPlayer
@export var good_order_sound : AudioStream
@export var bad_order_sound : AudioStream
@export var critique_bad_order_sound : AudioStream
@export var critique_good_order_sound : AudioStream

# -- signal --

signal finish_command(order: Order, success: bool)
signal successful_command(order: Order)
signal fail_command(order: Order)
signal new_command(order: Order)

# -- store --

var aviable_resources: Array[OrderResource]

var order_list: Array[Order] = []
var moved_order_last: Order = null

var total_client_count: int = 0
var total_inspection_count: int = 0

var next_client_time: float = -1
var next_inspection_turn_count: int

func has_order() -> bool:
	return !order_list.is_empty()

func last_order() -> Order:
	if (order_list.is_empty()): return null
	return order_list[0]

# call that each time you edit order_list
func check_move_next():

	if (order_list.is_empty()):
		if (ORDER_REFILL_EMPTY):
			var new_delta : float = randf_range(ORDER_REFILL_DELAY_MIN, ORDER_REFILL_DELAY_MAX)
			next_client_time = min(new_delta, next_client_time)
	else:
		var now_order_last = last_order()
		if (moved_order_last == now_order_last): return
		moved_order_last = now_order_last
		moved_order_last.character_body.play_arrive()

func set_flow_enable(state: bool):
	flow_enabled = state

# -- speed --

var speed_score: float = 0

func speed_up(score: float):
	speed_score += score
	if (speed_score < 0): speed_score = 0

func slow_down(score: float):
	speed_score -= score
	if (speed_score < 0): speed_score = 0

# more speed divide the value
func apply_speed_quotient(value: float, local_strength: float = 1) -> float:
	return value / (1 + (speed_score / 1000 * SPEED_STRENGTH * local_strength))

# more speed multiplicate the value
func apply_speed_factor(value: float, local_strength: float = 1) -> float:
	return value * (1 + (speed_score / 1000 * SPEED_STRENGTH * local_strength))

# -- difficulty --

# get an aoppropriated random resource
# TODO: is affected by turns count
func get_random_resource() -> OrderResource:
	return aviable_resources.pick_random()

func check_turn_unlock_resource(turn: int):
	var resource = unlock_turn_resources.get(turn)
	if (!resource): return
	aviable_resources.append(resource)

# check if should trigger inspection
func is_inspection_turn() -> bool:
	return next_inspection_turn_count <= 0
	# dont forget to call count_client(true) just after!

# called when client is going in, return if is an insp
func count_client(inspection: bool = false):
	total_client_count += 1
	check_turn_unlock_resource(total_client_count)

	next_inspection_turn_count -= 1
	if (inspection):
		total_inspection_count += 1
		next_inspection_turn_count = randi_range(INSPECTION_TURN_DELAY_MIN, INSPECTION_TURN_DELAY_MAX)

# called when client is going out
func count_service(success: bool = false):#inspection: bool = false
	if (success):
		speed_up(SPEED_UP_SUCCESS)
	else:
		slow_down(SLOW_DOWN_FAILURE)

# -- loop --

func _ready() -> void:
	aviable_resources = inital_resources
	next_inspection_turn_count = INSPECTION_FIRST_DELAY
	next_client_time = ORDER_FIRST_DELAY
	if (imediate_order):
		generate_order()

func _process(delta: float) -> void:
	if (!flow_enabled || delta == 0): return

	# expiration
	var expired_order = []
	for order in order_list:
		order.time_remain -= delta
		if (order.time_remain <= 0):
			expired_order.append(order)
	if (!expired_order.is_empty()):
		for order in expired_order:
			finish_order(order, false)
		check_move_next()
	
	# creation
	next_client_time -= delta
	if (next_client_time < 0 && order_list.size() < ORDER_GENERATE_MAX_QUEUE):
		generate_order()
	

# -- create --

# legit order (do that if not in cinematic)
func generate_order() -> void:
	print("generate an order, aviable:", aviable_resources.size(), " next_inspection:", next_inspection_turn_count)
	next_client_time = apply_speed_quotient(randf_range(ORDER_GENERATE_DELAY_MIN, ORDER_GENERATE_DELAY_MAX))
	call_order(get_random_resource(), is_inspection_turn())

# special function if you want an order to never expire
func call_infinite_order(new_order_resource: OrderResource, inspection: bool = false) -> void:
	call_order(new_order_resource, inspection, 1.79769e30)#1.79769e308 is the max but 1.79769e30 is still a lot

func call_infinite_critique(new_order_resource: OrderResource) -> void:
	call_order(new_order_resource, true, 1.79769e30)
	

# build your own order on order
func call_order(new_order_resource: OrderResource, inspection: bool = false, time_scale: float = 1) -> void:
	print("add a new order!", new_order_resource)
	var new_order_instance = packed_order.instantiate() as Order
	print("add order: BEFORE THE SOMETIMES CRASH", new_order_resource)
	var new_character = character_queue.generate_random_character(new_order_resource, inspection)
	print("add order: AFTER THE SOMETIMES CRASH", new_order_resource)
	new_order_instance.setup(new_order_resource, new_character, inspection, time_scale)

	ticket_container.add_child(new_order_instance)
	ticket_container.move_child(new_order_instance, 0)
	order_list.append(new_order_instance)
	check_move_next()

	count_client(inspection)
	#new_command.emit(new_order_instance)
	print("added a new order.")

func call_first_critique(new_order_resource: OrderResource) -> void :
	var new_order_instance = packed_order.instantiate() as Order
	var new_character = character_queue.generate_first_critique(new_order_resource)
	new_order_instance.setup(new_order_resource, new_character, true, 1.79769e30)
	ticket_container.add_child(new_order_instance)
	ticket_container.move_child(new_order_instance, 0)
	order_list.append(new_order_instance)
	check_move_next()

	count_client(true)
	new_command.emit(new_order_instance)

# -- finish --

func given_food(item: Item) -> void:
	print("given food to first order:", item)
	var order = last_order()
	var happy = order.given_happy(item)
	finish_order(order, happy)
	print("order is finish!")

func finish_order(order: Order, success: bool) -> void:
	finish_command.emit(order, success)
	if (success):
		_successful_order(order)
	else:
		_fail_order(order)

	order.character_body.play_quit()
	#order.character_body = null
	order_list.remove_at(order_list.find(order))
	order.queue_free()
	check_move_next()

	count_service(success)

func _successful_order(order: Order) -> void:
	if (order.is_inspector) :
		audio_player.stream = critique_good_order_sound
		audio_player.play(0)
	else :
		audio_player.stream = good_order_sound
		audio_player.play(0)
	print("successful order:", order)
	successful_command.emit(order)
	money_manager.earn(order.resource.price)
	money_manager.satisfaction(money_manager.MoneySatisfaction.HAPPY_CLIENT)

func _fail_order(order: Order) -> void:
	if (order.is_inspector) :
		audio_player.stream = critique_bad_order_sound
		audio_player.play(0)
	else :
		audio_player.stream = bad_order_sound
		audio_player.play(0)
	print("fail order:", order)
	fail_command.emit(order)
	var tige = FAIL_INSPECTOR_UNSTAR if (order.is_inspector) else FAIL_NORMAL_UNSTAR
	star_manager.remove_star(tige)
	money_manager.satisfaction(money_manager.MoneySatisfaction.ANGRY_CLIENT)#!
