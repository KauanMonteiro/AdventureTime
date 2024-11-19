extends AnimatedSprite2D
var boss = preload("res://scenes/enemies/demon_boss_10b.tscn")
func _ready():
	$magic.visible = false

func _on_area_2d_body_entered(body):
	
	if body is Player:
		body.set_process(false)
		body.set_physics_process(false)
		$summonaudio.play()
		var boss_instance = boss.instantiate()
		$".".play('default')
		await  $".".animation_finished
		await  $summonaudio.finished
		$magic.visible = true
		$magic.play("default")
		await $magic.animation_finished
		boss_instance.position= position + Vector2(0, -50)
		add_sibling(boss_instance)
		$".".queue_free()
		body.set_process(true)
		body.set_physics_process(true)
