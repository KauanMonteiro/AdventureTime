extends AnimatedSprite2D

# Variáveis para controlar o tempo do double jump
var double_jump_time = 2.0  # Tempo de duração do double jump em segundos
var double_jump_timer = 0.0  # Timer para controlar o tempo restante
var is_double_jump_active = false  # Flag para verificar se o double jump está ativo

func _ready():
	$".".play('default')

func _on_area_2d_body_entered(body):
	if body is Player:  
		$".".visible = true
		body.double_jump = true  # Habilita o double jump
		is_double_jump_active = true  # Marca que o double jump está ativo
		double_jump_timer = double_jump_time  # Reseta o timer para o valor máximo

func _process(delta):
	# Verifica se o double jump está ativo e faz o countdown
	if is_double_jump_active:
		double_jump_timer -= delta  # Subtrai o delta (tempo passado desde o último frame)
		
		# Se o tempo de double jump acabou, desativa a funcionalidade
		if double_jump_timer <= 0:
			is_double_jump_active = false
			var player = $"../player"
			if player:
				$".".visible = false
				player.double_jump = false  # Desativa o double jump para o jogador
