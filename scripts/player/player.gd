extends CharacterBody2D 
class_name Player

@onready var animation = $AnimatedSprite2D
@export var speed = 150
@export var jump_force = -300.000
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var key = false
var offset_x = -2
@export var double_jump = false
@onready var jump = $jump
@export var attacking = false
@export var dash = false
@export var dash_velocity = 900
var health = 2
@export var dash_duration = 0.2
@export var dash_cooldown = 1.0
var is_dashing = false
var dash_timer = 0.0
const fireattack_scene = preload("res://scenes/player/fireattck.tscn")
var is_attcking_spell = false
@export var mana = 2
@export var spell1_cost = 1
@export var mana_regeneration_rate = 1
@export var mana_regeneration_delay = 5
var mana_regeneration_timer = 0.0
@onready var spell_position = $spell_position
@onready var spell_attack2 = false
@export var spell2_cost = 2
var is_invulnerable = false


func _ready():
	$hurricane_attack.visible = false

func _process(delta):
	if Input.is_action_just_pressed("ui_attack"):
		attack()
	
	if mana < 3:
		mana_regeneration_timer -= delta
		if mana_regeneration_timer <= 0:
			mana += mana_regeneration_rate
			mana = clamp(mana, 0, 2)
			mana_regeneration_timer = mana_regeneration_delay

func _physics_process(delta):
	if Input.is_action_just_pressed('ui_spell_attack2') and spell_attack2:
		attacking = true
		if mana >= spell2_cost:
			mana -= spell2_cost
			$AnimatedSprite2D.play("hurricane")
			$hurricane_attack.visible = true
			var overlapping_bodies = $hurricane_attack.get_overlapping_bodies()
			is_invulnerable = true  
			for body in overlapping_bodies:
				if body.has_method("take_damage"):
					body.take_damage(4)
			await $AnimatedSprite2D.animation_finished
			$hurricane_attack.visible = false
			attacking = false
			is_invulnerable = false 

	if Input.is_action_just_pressed("ui_dash") and not is_dashing and dash:
		is_dashing = true
		dash_timer = dash_duration
		velocity.x = dash_velocity * (animation.scale.x)
		dash = false
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			await get_tree().create_timer(dash_cooldown).timeout

	if Input.is_action_just_pressed("ui_left"):
		animation.scale.x = -1
		$CollisionShape2D.position.x = -offset_x
		$attackarea.scale.x = abs($attackarea.scale.x) * -1

	if Input.is_action_just_pressed("ui_right"):
		animation.scale.x = 1
		$CollisionShape2D.position.x = offset_x
		$attackarea.scale.x = abs($attackarea.scale.x)
	
	if Input.is_action_just_pressed("ui_spell_attack"):
		if mana >= spell1_cost:
			attacking = true
			animation.play("attack")
			await animation.animation_finished
			is_attcking_spell = true
			spell_attack1()
			attacking = false
			mana -= spell1_cost
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = jump_force
			jump.play()
		elif double_jump:
			velocity.y = jump_force - 105
			double_jump = false
			jump.play()

	var direction = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("ui_left"):
		if sign(spell_position.position.x) == 1:
			spell_position.position.x *= -1
	if Input.is_action_pressed("ui_right"):
		if sign(spell_position.position.x) == -1:
			spell_position.position.x *= -1

	if not is_dashing:
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	update_animation()
	move_and_slide()

func attack():
	attacking = true
	$attackarea/attack.disabled = false
	animation.play("attack")
	await animation.animation_finished
	attacking = false
	$attackarea/attack.disabled = true
	var overlapping_bodies = $attackarea.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.has_method("take_damage"):
			body.take_damage(1)

func update_animation():
	if !attacking:
		$attackarea/attack.disabled = true
		if velocity.x != 0:
			animation.play("run")
		else:
			animation.play("idler")
		if velocity.y < 0:
			animation.play("jump")

func take_damage_player(damage_amount):
	if is_invulnerable:
		return
	
	health -= damage_amount
	if health <= 0:
		die()

func die():
	animation.play("die")
	set_process(false)
	set_physics_process(false)
	await animation.animation_finished
	GameManager.die()

func spell_attack1():
	var spell_attack1_instance = fireattack_scene.instantiate()
	if sign(spell_position.position.x) == 1:
		spell_attack1_instance.set_direction(1)
	else:
		spell_attack1_instance.set_direction(-1)
	add_sibling(spell_attack1_instance)
	spell_attack1_instance.global_position = spell_position.global_position
