extends Node
@export var music_boss = false
# Lista de músicas
var music_tracks = {
	#LEVEL 1 AO 4
	"fase1":"res://sound/696408_bloodpixelhero_adventure-theme-9 (online-audio-converter.com).mp3",
	#LEVEL 5
	"fase5":"res://sound/gamemusic (online-audio-converter.com).mp3",
	# LEVEL 6B 
	"fase6B":"res://sound/dungeon (online-audio-converter.com).mp3",
	# LEVEL 6A 
	"fase6A":"res://sound/2024-10-17 10-32-21 (online-audio-converter.com).mp3",
	#BOSS1A
	"fase10A":"res://sound/2024-10-31 15-26-44 (online-audio-converter.com).mp3",
	#fase9B
	"fase9B":"res://sound/724507_bloodpixelhero_prepare-for-battle (online-audio-converter.com).mp3",
	#BOSS1B
	'fase10B':"res://sound/608620_bloodpixelhero_retro-horror-loop (online-audio-converter.com).mp3",
	#fase6C
	'fase6c':"res://sound/ice.mp3",
	'frostboss':"res://sound/frostboss.mp3",
	#FASE11A
	'fase11a':"res://sound/646409_bloodpixelhero_adventure-theme-6 (online-audio-converter.com).mp3",
	#FASE11B
	'fase11b':"res://sound/2024-12-02 11-09-33 (online-audio-converter.com).mp3",
	'fase15':"res://sound/2024-12-06 08-23-21 (online-audio-converter.com).mp3",
	'final':"res://sound/2024-12-05 09-35-15 (online-audio-converter.com).mp3",
	'demon_mage':"res://sound/2024-12-03 09-31-19 (online-audio-converter.com).mp3",
	'DemonMorph':"res://sound/2024-12-03 09-24-18 (online-audio-converter.com).mp3",
	'BringerOfDeath':"res://sound/2024-12-03 09-37-18 (online-audio-converter.com).mp3",
	'demon_sword':"res://sound/2024-12-03 09-40-27 (online-audio-converter.com).mp3",
	'UndeadExecutioner':"res://sound/2024-12-03 09-44-32 (online-audio-converter.com).mp3",
}

# Variável para o AudioStreamPlayer
var audio_player: AudioStreamPlayer

# Método para inicializar o gerenciador
func _ready():
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)

# Método para tocar uma música de uma fase específica
func play_music(fase: String):
	if fase in music_tracks:
		audio_player.stream = load(music_tracks[fase])
		audio_player.play()
	else:
		print("Fase não encontrada: ", fase)

# Método para definir o volume
func set_volume(volume: float):
	audio_player.volume_db = volume

# Métodos para aumentar e diminuir o volume
func increase_volume(increment: float = 1.0):
	audio_player.volume_db += increment

func decrease_volume(decrement: float = 1.0):
	audio_player.volume_db -= decrement
