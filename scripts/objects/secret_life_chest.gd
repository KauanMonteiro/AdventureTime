extends Node2D
@onready var animated2= $AnimatedSprite2D2
@onready var animated1 = $AnimatedSprite2D
var open = false
func _ready():
	animated1.play("idler")
	animated2.visible = false


func _on_area_2d_body_entered(body):
	if body is Player:
		if open == false:
			animated1.play("open")
			await  animated1.animation_finished
			animated2.visible = true
			animated2.play("default")
			await animated2.animation_finished
			animated2.queue_free()
			body.health += 1
			open = true
