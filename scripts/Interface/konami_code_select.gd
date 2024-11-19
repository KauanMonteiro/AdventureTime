extends CanvasLayer

@onready var fase_1 = $"menu_holder/fase 1"
@onready var trasition_animation = $"transition/fill/Animation"

func _ready():
	fase_1.grab_focus()

func _on_fase_1_pressed():
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_1.tscn")

func _on_fase_2_pressed():
	MusicManager.play_music("fase1")
	MusicManager.increase_volume(1.0)
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_2.tscn")

func _on_fase_3_pressed():
	MusicManager.play_music("fase1")
	MusicManager.increase_volume(1.0)
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_3.tscn")

func _on_fase_4_pressed():
	MusicManager.play_music("fase1")
	MusicManager.increase_volume(1.0)
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_4.tscn")

func _on_fase_5_pressed():
	MusicManager.play_music("fase5")
	MusicManager.decrease_volume(8)
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_5.tscn")

func _on_fase_6a_pressed():
	MusicManager.play_music("fase6A")
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_6a.tscn")

func _on_fase_6b_pressed():
	MusicManager.play_music("fase6B")
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_6b.tscn")

func _on_fase_6c_pressed():
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_6c.tscn")

func _on_fase_7a_pressed():
	MusicManager.play_music("fase6A")
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_7a.tscn")

func _on_fase_7b_pressed():
	MusicManager.play_music("fase6B")
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_7b.tscn")

func _on_fase_8a_pressed():
	MusicManager.play_music("fase6A")
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_8a.tscn")

func _on_fase_8b_pressed():
	MusicManager.play_music("fase6B")
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_8b.tscn")

func _on_fase_9a_pressed():
	MusicManager.play_music("fase6A")
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_9a.tscn")

func _on_fase_9b_pressed():
	MusicManager.play_music("fase9B")
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_9b.tscn")

func _on_fase_10a_pressed():
	MusicManager.play_music("fase10A")
	MusicManager.increase_volume(-3.0)
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_10a_boss.tscn")

func _on_fase_10b_pressed():
	MusicManager.play_music("fase10B")
	MusicManager.decrease_volume(12.5)
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_10b.tscn")

func _on_fase_11a_pressed():
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_11a.tscn")

func _on_fase_11b_pressed():
	trasition_animation.play("trasition_out")
	await trasition_animation.animation_finished
	get_tree().change_scene_to_file("res://levelscenes/level_11b.tscn")
