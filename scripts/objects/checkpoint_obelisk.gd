extends AnimatedSprite2D
const SPELL_2_ICON = preload("res://scenes/objects/spell_2_icon.tscn")
var add_life = true
func _ready():
	$".".play('default')
func _on_area_2d_body_entered(body):
	if body is Player:
		Checkpoint.last_position = global_position
		if add_life:
			body.health += 2
			add_life = false
		var spell = SPELL_2_ICON.instantiate()
		if !body.spell_attack2:
			spell.global_position = body.global_position + Vector2(0, -30)
			add_sibling(spell)
			
