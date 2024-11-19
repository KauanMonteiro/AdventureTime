extends CharacterBody2D

enum StateMachine {
	IDLE,
	RUN,
	ATTACK1,
	ATTACK2,
	DEATH
}

@export var speed := 100
@export var dist_follow := 250
@export var dist_attack := 450
@export var dist_attack_melle := 25
var distance := 0.0

@export var health := 30
var animation := ""
var state = StateMachine.IDLE
var direction = 0  # 1 for right, -1 for left
var death = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player = $AnimationPlayer
@onready var player = $"../player"
@onready var attackarea= $attackarea/laserArea


const ARM_scene = preload("res://scenes/enemies/arm_projectile.tscn")  # Using the correct projectile scene

var attack_delay = 1.2
var can_attack = true  # Flag to check if the enemy can attack

func _ready() -> void:
	$spell_position.position.x = 1
	$Sprite2D.scale.x = 1
	direction = 1 
	$attackarea.scale.x = 1
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
				var overlapping_bodies = $attackarea.get_overlapping_bodies()
				for body in overlapping_bodies:
					if body.has_method("take_damage_player"):
						body.take_damage_player(1)
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
			_set_animation("idler") 
		StateMachine.ATTACK1:
			_set_animation("attack1")
		StateMachine.ATTACK2:
			_set_animation("attack2")
		StateMachine.DEATH:
			_set_animation("die")

func _flip() -> void:
	if global_position.x < player.global_position.x:
		direction = 1  
		$Sprite2D.scale.x = 1
		$attackarea.scale.x = 1
	elif global_position.x > player.global_position.x:
		direction = -1  
		$Sprite2D.scale.x = -1
		$attackarea.scale.x = -1
		
		

func spell_attack1() -> void:
	var spell_attack1_instance = ARM_scene.instantiate()  # Instantiate the projectile
	spell_attack1_instance.set_direction(direction)
	get_parent().add_child(spell_attack1_instance)
	spell_attack1_instance.global_position = $spell_position.global_position
	spell_attack1_instance.global_position.y += 10
	can_attack = false  # Block further attacks
	await get_tree().create_timer(attack_delay).timeout  # Wait for delay
	can_attack = true  # Enable attacks again
	
func die() -> void:
	if not death:
		death = true
		$"../block3".queue_free()
		_enter_state(StateMachine.DEATH)

func take_damage(damage_amount: int) -> void:
	health -= damage_amount
	if health <= 0:
		die()


func _on_attackarea_body_entered(body):
	if state != StateMachine.DEATH and body is Player:
		if body.has_method("take_damage_player"):
			body.take_damage_player(0.5)
