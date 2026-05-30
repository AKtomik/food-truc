class_name StartPhone
extends ItemTool

@export var collision: CollisionShape3D

@onready var sound_ring: AudioStreamPlayer = $%PhoneAudio
@onready var label: Label3D = $%ExclamationLabel

signal pickup()

func ring(ringing = true):
	collision.disabled = !ringing
	label.visible = ringing
	if (ringing):
		sound_ring.play()
	else:
		sound_ring.stop()

func can_put(_item: Item) -> bool:
	clicked()
	return false#dont touch!

func can_take(_item: Item) -> bool:
	clicked()
	return false#dont touch!
	
func clicked():
	pickup.emit()
