extends AnimatedSprite2D
const SPELL_2_ICON = preload("res://scenes/objects/spell_2_icon.tscn")
var add_life = true
@export var life = 2
func _ready():
	$".".play()
func _on_area_2d_body_entered(body):
	if body is Player:
		var spell = SPELL_2_ICON.instantiate()
		Checkpoint.last_position = global_position
		if add_life:
			body.health += life
			add_life = false
		if !body.spell_attack2:
			spell.position = body.position + Vector2(0, -15)  # 50 pixels acima da posição do jogador
			add_sibling(spell)
			
