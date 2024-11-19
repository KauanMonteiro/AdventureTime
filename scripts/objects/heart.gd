extends AnimatedSprite2D


func _ready():
	$".".play('default')

func _on_area_2d_body_entered(body):
	if body is Player:
		body.health += 1
		queue_free()
