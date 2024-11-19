extends Area2D

var fire_speed := 200
var direction := Vector2(1, -1)  # Direção inicial
var is_falling := false
var velocity := Vector2()  # Velocidade da bomba
var lifespan := 0.5  # Tempo antes de começar a cair
var time_elapsed := 0.0  # Tempo decorrido
var damage := 3  # Dano causado pela bomba


func _ready():
	$AnimationPlayer.play("idler")

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()

func _process(delta):
	if not is_falling:
		time_elapsed += delta  # Incrementa o tempo decorrido
		position += direction * fire_speed * delta  # Move na direção especificada

		if time_elapsed >= lifespan:
			_start_falling()
	else:
		# Aplica gravidade
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
		position.y += velocity.y * delta  # Move a bomba para baixo

		# Verifica colisão manualmente
		check_collision()

	# Remove a bomba se sair da tela
	if position.x < 0 or position.x > get_viewport().size.x:
		queue_free()

func _start_falling() -> void:
	is_falling = true
	direction = Vector2.ZERO

func check_collision():
	# Verifica se a bomba está colidindo com algo
	var bodies = get_overlapping_bodies()  # Obtém os corpos que estão sobrepostos

	for body in bodies:
		if body is TileMap:
			_on_collision(body)

func _on_collision(collision):
	# Lógica ao colidir com um objeto
	position.y = collision.position.y  # Ajusta a posição para não "varar"
	is_falling = false
	velocity = Vector2.ZERO
	queue_free()  # Remove a bomba

func _on_body_entered(body):
	if body is Player:
		$AnimationPlayer.play("booom")
		GameManager.die()
