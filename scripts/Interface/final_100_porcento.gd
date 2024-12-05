extends Control

func _ready():
	MusicManager.play_music('final')
	$Button.grab_focus()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/interface/title_screen.tscn")
