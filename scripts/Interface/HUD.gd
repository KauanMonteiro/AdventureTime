extends Control

@onready var death_counter = $Container/death_container/death_counter as Label

func _ready():
	death_counter.text = str(GameManager.death)
func _process(delta):
	death_counter.text = str(GameManager.death)
	
