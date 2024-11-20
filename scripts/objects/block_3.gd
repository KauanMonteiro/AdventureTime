extends StaticBody2D


func _ready():
	if GameManager.mecha_boss:
		queue_free()
