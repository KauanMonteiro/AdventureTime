extends Node2D
@onready var sprite = $Sprite2D

func _ready():
	sprite.visible = true
func _on_area_2d_body_entered(body):
	if body is Player:
		sprite.visible = false
