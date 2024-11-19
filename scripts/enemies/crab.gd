extends CharacterBody2D

enum StateMachine {
	IDLE,
	RUN,
	ATTACK,
	DEATH
}

@export var  speed := 80
@export var  dist_follow := 100
@export var dist_attack := 30

var distance := 0.0
@export var health := 2
var animation := ""
var state = StateMachine.IDLE
var direction = 0
var death = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = $"../player"
@onready var attack_area= $attackarea/attack

func _ready() -> void:
	attack_area.scale.x = 1
	$AnimatedSprite2D.scale.x = 1
	direction = 1
	attack_area.disabled= true

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
			elif distance < dist_attack:
				_enter_state(StateMachine.ATTACK)

		StateMachine.ATTACK:
			_set_animation("attack")
			attack_area.disabled= false  # Ativa a área de ataque
			if not animation_player.is_playing():
				var overlapping_bodies = $attackarea.get_overlapping_bodies()
				for body in overlapping_bodies:
					if body.has_method("take_damage_player"):
						body.take_damage_player(1)
				attack_area.disabled=true 
				_enter_state(StateMachine.IDLE)

		StateMachine.DEATH:
			if not animation_player.is_playing():
				queue_free()

func _enter_state(new_state: StateMachine) -> void:
	if state != new_state:
		state = new_state
		_set_animation_state(new_state)

func _set_animation(anim: String) -> void:
	if animation != anim:
		animation = anim
		animation_player.play(animation)

func _set_animation_state(new_state: StateMachine) -> void:
	match new_state:
		StateMachine.IDLE:
			_set_animation("idler")
		StateMachine.RUN:
			_set_animation("run")
		StateMachine.ATTACK:
			_set_animation("attack")
		StateMachine.DEATH:
			_set_animation("die")

func _flip() -> void:
	if global_position.x < player.global_position.x:
		$AnimatedSprite2D.scale.x = 1
		attack_area.scale.x = 1
		direction = 1
	elif global_position.x > player.global_position.x:
		$AnimatedSprite2D.scale.x = -1
		attack_area.scale.x = -1
		direction = -1

func _on_player_position_changed(new_position: Vector2) -> void:
	if state == StateMachine.DEATH:
		return

	distance = global_position.distance_to(new_position)

	match state:
		StateMachine.IDLE:
			if distance < dist_follow:
				_enter_state(StateMachine.RUN)

		StateMachine.RUN:
			if distance > dist_follow:
				_enter_state(StateMachine.IDLE)
			elif distance < dist_attack:
				_enter_state(StateMachine.ATTACK)

		StateMachine.ATTACK:
			if distance > dist_attack:
				_enter_state(StateMachine.RUN)

func take_damage(damage_amount: int) -> void:
	health -= damage_amount
	if health <= 0:
		die()

func die() -> void:
	if not death:
		death = true
		_enter_state(StateMachine.DEATH)

func _on_attack_area_area_entered(area: Area2D) -> void:
	if state != StateMachine.DEATH and area.is_in_group("player"):
		if area.has_method("take_damage_player"):
			area.take_damage_player(1)
