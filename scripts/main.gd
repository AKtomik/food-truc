class_name GameManager
extends Node3D

@export var cam : SlideCamera
@export var hand : Hand
@export var typewriter_label : TypeWriter
@export var face_picker : FacePicker
@export var order_manager : OrdersManager

@onready var phone_audio_player : AudioStreamPlayer = %PhoneAudioStream
@onready var music_audio_player : AudioStreamPlayer = %MusicAudioPlayer
@onready var in_tuto : bool = true

var tuto_order_count = 0
var tutoResourceFries : OrderResource = load("res://resources/order/order_fries.tres")
var tutoResourceSteak : OrderResource = load("res://resources/order/order_steak.tres")
var tutoResourceSalad : OrderResource = load("res://resources/order/order_salad.tres")

func _ready() -> void:
	face_picker.setup()
	order_manager.finish_command.connect(manage_spawn_tuto)
	_stop_time()
	phone_audio_player.stream = load("res://assets/sounds/ringtone.mp3")
	phone_audio_player.stream.loop = true
	phone_audio_player.play()
	# TEMPORARY
	start_game()

func _process(_delta: float) -> void:
	pass

func _stop_time():
	Engine.time_scale = 0

func _start_time():
	Engine.time_scale = 1

func start_game():
	_start_time()
	phone_audio_player.stop()
	typewriter_label.display("Si tu veux pas d’emmerdes, écoute-moi bien. J’me répéterai pas.", load("res://assets/sounds/rendu-002.wav"), 0.8, 0.045)
	await get_tree().create_timer(4.0).timeout
	typewriter_label.display("Tu dois faire tourner la boutique. Si tu te foires, c’est game over", null, 0, 0.035)
	cam.set_enable_move(true)# can be delayed in anim
	hand.set_enable_click(true)# can be delayed in anim
	order_manager.call_infinite_order(tutoResourceFries)
	await get_tree().create_timer(2.5).timeout
	typewriter_label.display("Tu récupères les commandes, tu prépares la bouffe… et surtout, SOIS rentable.", null, 0, 0.042)
	await get_tree().create_timer(3.4).timeout
	typewriter_label.display("Que les clients bouffent mal, j’m’en fous. Fais rentrer le pognon dans la caisse.")

func manage_spawn_tuto(order: Order, success: bool) :
	if (!in_tuto) :
		return
	tuto_order_count += 1
	if (tuto_order_count == 1) :
		order_manager.call_infinite_order(tutoResourceSteak)
		order_manager.call_infinite_order(tutoResourceFries)
	elif (tuto_order_count == 3) :
		phone_audio_player.play()
	elif (tuto_order_count == 4) :
		end_tuto()
			

func tutorial_critique() :
	phone_audio_player.stop()
	typewriter_label.display("Si tu vois un mec un peu chelou en costard, lui tu me le foires pas.", load("res://assets/sounds/rendu-003.wav"), 0, 0.045)
	await get_tree().create_timer(3.2).timeout
	order_manager.call_first_critique(tutoResourceSalad)
	typewriter_label.display("Ce gars, C’est un enfoiré de critique culinaire, il traîne toujour autour de mes magouilles.", null, 0, 0.045)
	await get_tree().create_timer(4.2).timeout
	typewriter_label.display("sert lui de la qualité, il faut que ce soit irréprochable", null, 0, 0.045)
	await get_tree().create_timer(3.2).timeout
	typewriter_label.display("notre dernier resto a fermé à cause de lui, il s'est déguisé pour passer inaperçu", null, 0, 0.04)
	await get_tree().create_timer(3.3).timeout
	typewriter_label.display("Et le gars qui occupait ton poste avant toi n'y a vu que du feu.", null, 0, 0.045)
	await get_tree().create_timer(4.5).timeout
	typewriter_label.display("Quoi !? Qu'est ce qui est arrivé a ton prédecesseur ? Depuis quand t'as le droit de poser des question toi ?", null, 0, 0.032)
	await get_tree().create_timer(5.5).timeout
	music_audio_player.stream =  load("res://assets/sounds/Main_theme.mp3")
	music_audio_player.stream.loop = true
	music_audio_player.play()
			
func end_tuto() :
	in_tuto = false
	order_manager.set_flow_enable(true)
