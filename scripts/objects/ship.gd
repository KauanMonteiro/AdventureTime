extends AnimatedSprite2D
@onready var ship = $"."
@onready var animated= $AnimatedSprite2D
@onready var trasition_animation = $"../transition/fill/Animation"

func _ready():
	ship.play("default")
	animated.play("default")


func _on_area_2d_body_entered(body):
	if body is Player:
		if body.key == true:
			trasition_animation.play("trasition_out")
			await  trasition_animation.animation_finished
			MusicManager.play_music("fase10A")
			MusicManager.increase_volume(-3.0)
			get_tree().change_scene_to_file("res://levelscenes/level_10a_boss.tscn")
