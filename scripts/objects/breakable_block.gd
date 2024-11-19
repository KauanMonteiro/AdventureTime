extends Node2D

func _on_area_2d_body_exited(body):
	if body is Player:
		$AnimatedSprite2D.play("default") 
		await $AnimatedSprite2D.animation_finished
		queue_free()
