extends Node

@onready var ashes: AudioStreamPlayer = $AshesMusic

func play_music() -> void:
	ashes.play()
