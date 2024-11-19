extends Node2D


func _on_detect_body_entered(body):
	if body is Player:
		$AnimationPlayer.play("default")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("RESET")
		



func _on_area_2d_2_body_entered(body):
	if body is Player:
		if body.has_method("take_damage_player"):
			body.take_damage_player(0.5)
