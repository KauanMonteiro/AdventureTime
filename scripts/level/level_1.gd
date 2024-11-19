extends Node2D

func _ready():
	# Toca a música da fase 1 ao iniciar
	MusicManager.play_music("fase1")
	MusicManager.increase_volume(1.0)
