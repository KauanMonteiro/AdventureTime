extends Area2D

func _ready():
	$AnimatedSprite2D.play("default")
	$Node2D.visible = false
func _on_body_entered(body):
	if body is Player:
		$Node2D.visible=true
