extends Control
@onready var start_bnt = $MarginContainer/HBoxContainer/VBoxContainer/start_bnt

func _ready():
	MusicManager.play_music("titulo")
	MusicManager.increase_volume(1.0)
	start_bnt.grab_focus()

func _on_start_bnt_pressed():
	get_tree().change_scene_to_file("res://levelscenes/level_1.tscn")

func _on_quit_bnt_pressed():
	get_tree().quit()
