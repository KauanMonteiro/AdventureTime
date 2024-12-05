extends Area2D


func _on_body_entered(body):
	if body is Player:
		if GameManager.Demon_sword:
			MusicManager.play_music('fase11b')
		else:
			MusicManager.play_music('demon_sword')
