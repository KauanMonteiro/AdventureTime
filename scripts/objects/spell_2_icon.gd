extends Sprite2D

func _on_area_2d_body_entered(body):
	if body is Player:
		body.spell_attack2 = true
		queue_free()