extends AudioStreamPlayer

var music: Array[AudioStream] = [
	preload("uid://kgnyyav7ca63"),
	preload("uid://dd2uuqbbvpwek"),
	preload("uid://cm1bp441tv27r"),
	preload("uid://c6cibovuc6imx"),
	preload("uid://b2tpdg47lb3xe"),
]
var menu_music = preload("uid://csijk4ktvlku2")


func play_music():
	stream = music.pick_random()
	play()


func _process(_delta: float) -> void:
	volume_linear = Global.music_volume


func _ready() -> void:
	play()
	Global.game_started.connect(play_music)
