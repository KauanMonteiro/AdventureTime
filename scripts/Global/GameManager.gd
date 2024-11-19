extends Node

var death:= 0

func die():
	death += 1
	get_tree().reload_current_scene()
	

