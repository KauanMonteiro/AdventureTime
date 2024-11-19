extends Node

# Defina a sequência de teclas (Konami Code)
var konami_code = [
	"ui_up", "ui_up", "ui_down", "ui_down", "ui_left", "ui_right", "ui_left", "ui_right",
	"ui_accept", "ui_spell_attack"
]

# Armazena as teclas pressionadas pelo jogador
var input_sequence = []

# Flag para garantir que a ação do código não seja ativada mais de uma vez
var is_code_active = false

# Função chamada a cada quadro (frame)
func _process(delta):
	# Verifica se a tecla foi pressionada
	if Input.is_action_just_pressed("ui_up"):
		input_sequence.append("ui_up")
	elif Input.is_action_just_pressed("ui_down"):
		input_sequence.append("ui_down")
	elif Input.is_action_just_pressed("ui_left"):
		input_sequence.append("ui_left")
	elif Input.is_action_just_pressed("ui_right"):
		input_sequence.append("ui_right")
	elif Input.is_action_just_pressed("ui_accept"):
		input_sequence.append("ui_accept")
	elif Input.is_action_just_pressed("ui_spell_attack"):
		input_sequence.append("ui_spell_attack")


	# Verifica se a sequência de entradas corresponde ao Konami Code
	if input_sequence == konami_code:
		on_konami_code_detected()

	# Limita o tamanho da sequência armazenada para não ficar muito grande
	if input_sequence.size() > konami_code.size():
		# Remove o primeiro item da sequência para manter o tamanho correto
		input_sequence.erase(input_sequence[0])  # Remove o primeiro item

# O que acontece quando a sequência é detectada
func on_konami_code_detected():
	if not is_code_active:
		is_code_active = true
		get_tree().change_scene_to_file("res://scenes/interface/konami_code.tscn")
		is_code_active = false
