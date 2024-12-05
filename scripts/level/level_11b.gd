extends Node2D


func _process(delta):
	if GameManager.demon_mage and GameManager.DemonMorph and GameManager.Demon_sword and GameManager.UndeadExecutioner and GameManager.BringerOfDeath:
		GameManager.rota3 = true
		get_tree().change_scene_to_file("res://levelscenes/tela_de_encerramento_1.tscn")
			
func _enter_tree():
	if Checkpoint.last_position:
		$player.global_position = Checkpoint.last_position
	

