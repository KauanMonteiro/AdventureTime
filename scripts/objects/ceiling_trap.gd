extends Node2D


func _on_detect_body_entered(body):
	if body is Player:
		$AnimationPlayer.play("default")



func _on_attack_body_entered(body):
	if body is Player:
		GameManager.die()
