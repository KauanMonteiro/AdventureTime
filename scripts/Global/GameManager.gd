extends Node

var death:= 0
@export var mecha_boss = false

@export var rota1 = false
@export var rota2 = false
@export var rota3 = false
#fase11b
@export var demon_mage = false
@export var Demon_sword = false
@export var DemonMorph = false
@export var UndeadExecutioner = false
@export var BringerOfDeath = false

func die():
	death += 1
	get_tree().reload_current_scene()
	
func _process(delta):
	if rota1 and rota2 and rota3:
		get_tree().change_scene_to_file("res://scenes/interface/final_100_porcento.tscn")
