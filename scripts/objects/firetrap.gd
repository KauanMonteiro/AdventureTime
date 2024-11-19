extends Node2D


func _on_detect_body_entered(body):
	if body is Player:
		
		$AnimationPlayer.play("default")
		$AudioStreamPlayer2D.play()


func _on_fire_body_entered(body):
	if body is Player:
		GameManager.die()
