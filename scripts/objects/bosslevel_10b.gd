extends Area2D
@onready var trasition_animation = $"../transition/fill/Animation"

func _on_body_entered(body):
	if body is Player:
			trasition_animation.play("trasition_out")
			await  trasition_animation.animation_finished
			MusicManager.play_music("fase10B")
			MusicManager.decrease_volume(12.5)
			get_tree().change_scene_to_file("res://levelscenes/level_10b.tscn")
