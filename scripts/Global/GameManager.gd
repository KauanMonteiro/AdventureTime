extends Node

var death:= 0
@export var mecha_boss = false
func die():
	death += 1
	get_tree().reload_current_scene()
	

