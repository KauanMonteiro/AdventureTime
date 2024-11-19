extends Node2D

@export var speed = 600


func _on_area_2d_body_entered(body): 
	if body is Player:
		$AnimatedSprite2D.play("default")
		body.velocity.y = -speed
		$AudioStreamPlayer2D.play()
