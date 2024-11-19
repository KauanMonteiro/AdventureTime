extends CharacterBody2D

enum StateMachine {
	IDLE,
	RUN,
	ATTACK1,  # Ataque a distância
	ATTACK2,  # Ataque corpo-a-corpo
	DEATH
}

@export var speed := 100
@export var dist_follow := 250
@export var dist_attack := 450
@export var dist_attack_melle := 30  # Distância para o ataque corpo-a-corpo

var distance := 0.0

@export var health := 30
var animation := ""
var state = StateMachine.IDLE
var direction = 0  # 1 for right, -1 for left
var death = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player = $AnimationPlayer
@onready var player = $"../player"
@onready var attackarea = $attackarea  # Área de ataque para o corpo-a-corpo

const ARM_scene = preload("res://scenes/enemies/arm_projectile.tscn")  # Cena do projétil de ataque a distância

var attack_delay = 1.2
var can_attack = true  # Flag para verificar se o inimigo pode atacar

func _ready() -> void:
	$Sprite2D.scale.x = 1
	direction = 1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	distance = global_position.distance_to(player.global_position)

	match state:
		StateMachine.IDLE:
			_set_animation("idler")
			if distance < dist_follow:
				_enter_state(StateMachine.RUN)

		StateMachine.RUN:
			_set_animation("run")
			_flip()
			velocity.x = direction * speed
			move_and_slide()

			if distance > dist_follow:
				_enter_state(StateMachine.IDLE)
			elif distance < dist_attack and can_attack:
				_enter_state(StateMachine.ATTACK1)  # Ataque a distância
			elif distance < dist_attack_melle and can_attack:  # Ataque corpo-a-corpo
				_enter_state(StateMachine.ATTACK2)

		StateMachine.ATTACK2:
			_set_animation("attack")  # Animação de ataque corpo-a-corpo
			if not animation_player.is_playing():  # Espera a animação terminar
				var overlapping_bodies = $attackarea.get_overlapping_bodies()  # Verifica os corpos na área de ataque
				for body in overlapping_bodies:
					if body.has_method("take_damage_player"):
						body.take_damage_player(1)  # Aplica dano ao jogador
				_enter_state(StateMachine.IDLE)  # Retorna ao estado IDLE após o ataque

		StateMachine.DEATH:
			if not animation_player.is_playing():
				queue_free()  # Remove o inimigo quando ele morrer

# Função de transição entre estados
func _enter_state(new_state: StateMachine) -> void:
	if state != new_state:
		state = new_state
		_set_animation_state(new_state)

# Função para configurar a animação com base no estado
func _set_animation(anim: String) -> void:
	if animation != anim:
		animation = anim
		animation_player.play(animation)

# Função para definir a animação com base no estado
func _set_animation_state(new_state: StateMachine) -> void:
	match new_state:
		StateMachine.IDLE:
			_set_animation("idler")
		StateMachine.RUN:
			_set_animation("run")
		StateMachine.ATTACK1:
			_set_animation("attack1")  # Animação de ataque a distância
		StateMachine.ATTACK2:
			_set_animation("attack2")  # Animação de ataque corpo-a-corpo
		StateMachine.DEATH:
			_set_animation("die")

# Lógica de flip do sprite
func _flip() -> void:
	if global_position.x < player.global_position.x:
		direction = 1
		$Sprite2D.scale.x = 1
	elif global_position.x > player.global_position.x:
		direction = -1
		$Sprite2D.scale.x = -1

# Função para tomar dano (do jogador)
func take_damage(damage_amount: int) -> void:
	health -= damage_amount
	if health <= 0:
		die()

# Função de morte
func die() -> void:
	if not death:
		death = true
		$"../block3".queue_free()  # Pode ser usado para remover partes ou objetos do inimigo
		_enter_state(StateMachine.DEATH)
