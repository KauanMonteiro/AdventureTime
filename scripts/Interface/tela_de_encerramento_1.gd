extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicManager.play_music('final')
	$Button.grab_focus()


func _on_button_pressed():
	MusicManager.play_music('fase5')
	get_tree().change_scene_to_file("res://levelscenes/level_5.tscn")
