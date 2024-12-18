extends Node2D
const SPELL_2_ICON = preload("res://scenes/objects/spell_2_icon.tscn")

const HEART = preload("res://scenes/objects/heart.tscn")
func _ready():
	$AnimatedSprite2D.play("default")

func _on_area_2d_body_entered(body):
	if body is Player:
		$AnimatedSprite2D.play("open")
		await $AnimatedSprite2D.animation_finished
		if body.spell_attack2:
			var heart = HEART.instantiate()
			heart.position = body.position + Vector2(0, -15)
			add_sibling(heart)
		else:
			var spell = SPELL_2_ICON.instantiate()
			spell.position = body.position + Vector2(0, -15)  # 50 pixels acima da posição do jogador
			add_sibling(spell)
		queue_free()

