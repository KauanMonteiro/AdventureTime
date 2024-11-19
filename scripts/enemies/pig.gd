extends CharacterBody2D

enum StateMachine {
	IDLE,
	RUN,
	THROW,
	DEATH
}

@export var speed := 80
@export var dist_follow := 150  # Distance to start fleeing
@export var dist_attack := 300   # Distance at which to attack
@export var health := 3
@onready var spell_position = $spell_position

var distance := 0.0
var animation := ""
var state = StateMachine.IDLE
var direction = -1  # Start moving left
var death = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player = $AnimationPlayer
@onready var player = $"../player"

func _ready() -> void:
	$Sprite2D.scale.x = 1

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
			velocity.x = -direction * speed  # Invert direction to flee
			move_and_slide()

			if distance > dist_follow:
				_enter_state(StateMachine.IDLE)
			elif distance < dist_attack:
				_enter_state(StateMachine.THROW)

		StateMachine.THROW:
			if not animation_player.is_playing():  # Ensure throwing animation is not playing
				_set_animation("ThrowingBoom")
				_throw_bomb()
				_enter_state(StateMachine.RUN)  # Go back to running after throwing

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
		StateMachine.THROW:
			_set_animation("ThrowingBoom")
		StateMachine.DEATH:
			_set_animation("die")

func _flip() -> void:
	if global_position.x < player.global_position.x:
		$Sprite2D.scale.x = -1 
		direction = 1
	elif global_position.x > player.global_position.x:
		$Sprite2D.scale.x = 1 
		direction = -1

func _throw_bomb() -> void:
	var bomb_scene = preload("res://scenes/enemies/bomb.tscn")  # Path to the bomb scene
	var bomb_instance = bomb_scene.instantiate()
	
	# Position the bomb slightly above the character
	bomb_instance.global_position = position + Vector2(0, -20)  
	
	# Calculate the direction to the player
	var direction_to_player = (player.global_position - bomb_instance.global_position).normalized()
	bomb_instance.set_direction(direction_to_player)  # Set the bomb's throw direction
	
	get_parent().add_child(bomb_instance)



func take_damage(damage_amount: int) -> void:
	health -= damage_amount
	if health <= 0:
		die()

func die() -> void:
	if not death:
		death = true
		_enter_state(StateMachine.DEATH)
