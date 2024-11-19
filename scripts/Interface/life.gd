extends CanvasLayer

@onready var label = $Control/MarginContainer/HBoxContainer/Label
@onready var player = $"../player"


func _process(delta):
	atualizar_interface_vida()

# Atualiza o label com a vida atual do jogador
func atualizar_interface_vida() -> void:
	label.text = str(player.health)
