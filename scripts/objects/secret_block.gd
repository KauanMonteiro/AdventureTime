extends Node2D

var health := 3

func take_damage(damage_amount: int) -> void:
	health -= damage_amount
	if health <= 0:
		queue_free()

