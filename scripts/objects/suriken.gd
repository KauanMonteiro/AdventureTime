extends AnimatedSprite2D

func _ready():
	$".".play("idler")
	
func _on_area_2d_body_entered(body):
	if body is Player:
		body.key = false  
		GameManager.die()
