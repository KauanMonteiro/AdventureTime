extends CharacterBody2D

enum StateMachine {
	IDLE,
	ATTACK1,
	ATTACK2,
	DEATH
}

@export var speed := 100
@export var dist_attack := 450
@export var dist_attack_melle := 25
var distance := 0.0

@export var health := 3
var animation := ""
var state = StateMachine.IDLE
var direction = 0  # 1 for right, -1 for left
var death = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player = $AnimationPlayer
@onready var player = $"../player"
@onready var attackarea = $attackarea/laserArea

const arrow_scene = preload("res://scenes/enemies/arrow.tscn")   # Usando a cena de projétil correta

var attack_delay = 1.2
var can_attack = true  # Flag para verificar se o inimigo pode atacar

func _ready() -> void:
	$spell_position.position.x = 1
	$Sprite2D.scale.x = 1
	direction = 1 
	$attackarea.scale.x = 1

	# Estado inicial é "IDLE", o inimigo não vai seguir o jogador
	_enter_state(StateMachine.IDLE)

func _physics_process(delta: float) -> void:
	# Não há mais necessidade de gravidade se o inimigo não se move verticalmente
	if not is_on_floor():
		velocity.y += gravity * delta

	distance = global_position.distance_to(player.global_position)

	match state:
		StateMachine.IDLE:
			_set_animation("idler")
			_flip()  # Chama a função para virar o inimigo baseado na posição do jogador
			# O inimigo não vai seguir o jogador, agora apenas verifica se ele pode atacar.
			if distance < dist_attack and can_attack:
				_enter_state(StateMachine.ATTACK1)
			elif distance < dist_attack_melle:
				_enter_state(StateMachine.ATTACK2)

		StateMachine.ATTACK1:
			_set_animation("attack1")
			await $AnimationPlayer.animation_finished
			spell_attack1()
			_enter_state(StateMachine.IDLE)

		StateMachine.ATTACK2:
			_set_animation("attack2")
			if not animation_player.is_playing():
				_enter_state(StateMachine.IDLE)

		StateMachine.DEATH:
			if not animation_player.is_playing():
				queue_free()

# Alterando o estado do inimigo
func _enter_state(new_state: StateMachine) -> void:
	if state != new_state:
		state = new_state
		_set_animation_state(new_state)

# Configura a animação com base no estado
func _set_animation(anim: String) -> void:
	if animation != anim:
		animation = anim
		animation_player.play(animation)

# Configura a animação de acordo com o estado
func _set_animation_state(new_state: StateMachine) -> void:
	match new_state:
		StateMachine.IDLE:
			_set_animation("idler")
		StateMachine.ATTACK1:
			_set_animation("attack1")
		StateMachine.ATTACK2:
			_set_animation("attack2")
		StateMachine.DEATH:
			_set_animation("die")

# Para mudar a direção do inimigo com base na posição do jogador
func _flip() -> void:
	if global_position.x < player.global_position.x:
		direction = 1  
		$Sprite2D.scale.x = 1  # Inimigo virado para a direita
		$attackarea.scale.x = 1  # Área de ataque virada para a direita
	elif global_position.x > player.global_position.x:
		direction = -1  
		$Sprite2D.scale.x = -1  # Inimigo virado para a esquerda
		$attackarea.scale.x = -1  # Área de ataque virada para a esquerda
		
# Lógica de ataque com o projétil
func spell_attack1() -> void:
	var spell_attack1_instance = arrow_scene.instantiate()  # Instancia o projétil
	spell_attack1_instance.set_direction(direction)
	get_parent().add_child(spell_attack1_instance)
	spell_attack1_instance.global_position = $spell_position.global_position
	spell_attack1_instance.global_position.y + 30
	can_attack = false  # Bloqueia novos ataques até o delay terminar
	await get_tree().create_timer(attack_delay).timeout  # Espera o tempo do delay
	can_attack = true  # Libera o ataque novamente
	
# Função de morte do inimigo
func die() -> void:
	if not death:
		death = true
		_enter_state(StateMachine.DEATH)

# Função para o inimigo levar dano
func take_damage(damage_amount: int) -> void:
	health -= damage_amount
	if health <= 0:
		die()

# Detecção de colisão com a área de ataque
func _on_attackarea_body_entered(body):
	if state != StateMachine.DEATH and body is Player:
		if body.has_method("take_damage_player"):
			body.take_damage_player(0.5)
