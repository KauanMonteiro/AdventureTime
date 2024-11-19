extends Node2D

@onready var animated1 = $AnimatedSprite2D
@onready var trasition_animation = $"../transition/fill/Animation"
func _ready():
	animated1.play("idler")

func _on_area_2d_body_entered(body):
	if body is Player:
		if body.key == true:
			animated1.play("open")
			await  animated1.animation_finished
			trasition_animation.play("trasition_out")
			await  trasition_animation.animation_finished
			get_tree().change_scene_to_file('res://levelscenes/level_8b.tscn')
