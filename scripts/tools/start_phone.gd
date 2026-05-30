class_name StartPhone
extends ItemTool

@export var game_manager: GameManager
@export var collision: CollisionShape3D

@onready var sound_ring: AudioStreamPlayer = $%PhoneAudio

signal pickup()

func ring(ringing = true):
	if (ringing):
		sound_ring.play()
	else:
		sound_ring.stop()

	# now in editor:
	#phone_audio_player.stream = load("res://assets/sounds/ringtone.mp3")
	#phone_audio_player.stream.loop = true

func can_put(_item: Item) -> bool:
	clicked()
	return false#dont touch!

func can_take(_item: Item) -> bool:
	clicked()
	return false#dont touch!
	
func clicked():
	pickup.emit()
	if (!game_manager.in_tuto): return
	if (game_manager.tuto_call_count == 0):
		game_manager.first_call()
	if (game_manager.tuto_call_count == 1 && game_manager.tuto_order_count == 3):
		collision.disabled = true# kill the phone
		game_manager.second_call()
