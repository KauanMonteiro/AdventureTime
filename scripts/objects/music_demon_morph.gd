extends Area2D

func _on_body_entered(body):
	if body is Player:
		if GameManager.DemonMorph:
			MusicManager.play_music('fase11b')
		else:
			MusicManager.play_music('DemonMorph')
