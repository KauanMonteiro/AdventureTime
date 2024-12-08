extends AnimatedSprite2D

@onready var trasition_animation = $"../transition/fill/Animation"

func _on_area_2d_body_entered(body):
	if body is Player:
		if body.key == true:
			$".".play("open")
			await $".".animation_finished
			body.key = false
			trasition_animation.play("trasition_out")
			await  trasition_animation.animation_finished
			MusicManager.play_music("fase15")
			get_tree().change_scene_to_file("res://levelscenes/level_15a.tscn")
