extends Area2D
@onready var trasition_animation = $"../transition/fill/Animation"


func _on_body_entered(body):
	if body is Player:
		if GameManager.demon_mage and GameManager.DemonMorph and GameManager.Demon_sword and GameManager.UndeadExecutioner and GameManager.BringerOfDeath == true:
				get_tree().change_scene_to_file("res://levelscenes/tela_de_encerramento_1.tscn")
		
