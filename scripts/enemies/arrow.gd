extends Area2D

var fire_speed := 400
@export var direction := 1

func _ready():
	$AnimatedSprite2D.play("default")

func _process(delta):
	position.x += fire_speed * delta * direction

func set_direction(dir):
	direction = dir
	if dir < 0:
		$AnimatedSprite2D.set_flip_h(true)
	else :
		$AnimatedSprite2D.set_flip_h(false)

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body is Player:
		if body.has_method("take_damage_player"):
			body.take_damage_player(0.01)
			queue_free()
