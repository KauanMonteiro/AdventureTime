extends Node2D

@onready var suriken = $suriken
const WAIT_DURATION = 1.0
@export var move_speed = 3.0
@export var distance = 192
@export var move_horizontal = true

var follow = Vector2.ZERO
var platform_center = 16

func _ready()->void:
	$suriken/AnimatedSprite2D.play("default")
	move_platform()

func _physics_process(_delta: float)-> void:
	suriken.position = suriken.position.lerp(follow, 0.5)

func move_platform():
	var move_direction = Vector2.RIGHT * distance if move_horizontal else Vector2.UP * distance
	var duration = move_direction.length() / float(move_speed * platform_center)
	var platform_tween = suriken.create_tween().set_loops()
	
	platform_tween.tween_property(self,"follow", move_direction, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	platform_tween.tween_property(self,"follow", Vector2.ZERO, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func _on_area_2d_body_entered(body):
	if body is Player:
		body.key = false  
		GameManager.die()
