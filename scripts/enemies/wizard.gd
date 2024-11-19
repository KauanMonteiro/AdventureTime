extends CharacterBody2D

enum StateMachine {
	IDLE,
	RUN,
	ATTACK,
	DEATH,
	HEAL
}

@export var speed := 80
@export var dist_follow := 150
@export var dist_attack := 30
@export var heal_amount := 2  # Amount to heal
@export var healing_time := 2.0  # Duration of healing animation

var distance := 0.0
@export var health := 3
var animation := ""
var state = StateMachine.IDLE
var direction = 0
var death = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player = $AnimationPlayer
@onready var player = $"../player"
@onready var attack_area = $attackarea/attack

func _ready() -> void:
	attack_area.scale.x = 1
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
			elif distance < dist_attack:
				_enter_state(StateMachine.ATTACK)

		StateMachine.ATTACK:
			_set_animation("attack")
			if not animation_player.is_playing():
				var overlapping_bodies = $attackarea.get_overlapping_bodies()
				for body in overlapping_bodies:
					if body.has_method("take_damage_player"):
						body.take_damage_player(1)
				_enter_state(StateMachine.IDLE)

		StateMachine.DEATH:
			if not animation_player.is_playing():
				queue_free()

		StateMachine.HEAL:
			if not animation_player.is_playing():
				health += heal_amount
				_enter_state(StateMachine.IDLE)  # Return to idle after healing

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
		StateMachine.HEAL:
			_set_animation("heal")  # Add healing animation

func _flip() -> void:
	if global_position.x < player.global_position.x:
		$Sprite2D.scale.x = 1
		$attackarea.scale.x = 1
		direction = 1
	elif global_position.x > player.global_position.x:
		$Sprite2D.scale.x = -1
		$attackarea.scale.x = -1
		direction = -1

func take_damage(damage_amount: int) -> void:
	health -= damage_amount
	if health <= 0:
		die()
	elif health == 1:
		flee_and_heal()  # Call the flee and heal function

func flee_and_heal() -> void:
	if not death:
		_enter_state(StateMachine.HEAL)
		# Add logic to flee (e.g., move away from player)
		direction = -direction  # Change direction to flee
		velocity.x = direction * speed  # Move away from player
		move_and_slide()

		# Wait for healing time
		await get_tree().create_timer(healing_time).timeout  # Use await instead of yield
		health += heal_amount  # Heal the character after fleeing

func die() -> void:
	if not death:
		death = true
		_enter_state(StateMachine.DEATH)

func _on_attackarea_body_entered(body):
	if state != StateMachine.DEATH and body is Player:
		if body.has_method("take_damage_player"):
			body.take_damage_player(0.5)
