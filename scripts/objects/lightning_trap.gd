extends Node2D

var distance := 0.0
@onready var player = $"../player"
@export var dist:= 100  # Distância em que o inimigo entra em contato com o jogador

func _ready():
	# Talvez você queira calcular a distância inicial
	distance = global_position.distance_to(player.global_position)

func _process(delta):
	distance = global_position.distance_to(player.global_position)
	if distance < dist:
		$AnimationPlayer.play("default")
	else:
		$AnimationPlayer.play("RESET")


func _on_area_2d_body_entered(body):
	# Verifica se o corpo que entrou na área é o jogador
	if body is Player:
		# Ação quando o jogador colide (aqui, por exemplo, matando o jogador)
		GameManager.die()
