extends Area2D


func _on_body_exited(body):
	if body is  Player:
		if !MusicManager.music_boss:
			MusicManager.music_boss = true
			MusicManager.play_music('frostboss')
