extends Control
@export var bg_timer: Timer
@export var bg: ColorRect
@export var main_screen: NinePatchRect
@export var option_screen: NinePatchRect
@export var disable_checkpoint: CheckButton
@export var attack_mouse: CheckButton
@export var menu_sfx: AudioStreamPlayer

var game_started: bool = false

signal bloup_bloup(toggled_on: bool)
var bg_color := Color("00a17d")


func _process(_delta: float) -> void:
	bg.material.set_shader_parameter("color_1", bg_color)
	menu_sfx.volume_linear = Global.sfx_volume


func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(
		self,
		"bg_color",
		Color(randf(), randf(), randf(), 1.0),
		bg_timer.wait_time,
	)


func _on_play_pressed() -> void:
	hide()
	play_sfx()
	Global.game_started.emit()
	game_started = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	main_screen.hide()
	option_screen.show()
	play_sfx()


func _on_menu_pressed() -> void:
	if get_tree().paused && game_started:
		get_tree().paused = false
		pause_menu(false)
	else:
		main_screen.show()
		option_screen.hide()
	play_sfx()


func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.option_disable_checkpoint = toggled_on
	play_sfx()


func _on_attack_mouse_toggled(toggled_on: bool) -> void:
	Global.option_attack_mouse = toggled_on
	play_sfx()


func _ready() -> void:
	Global.option_disable_checkpoint = disable_checkpoint.button_pressed
	Global.option_attack_mouse = attack_mouse.button_pressed
	Global.game_paused.connect(pause_menu)


func pause_menu(on: bool):
	if on:
		show()
		main_screen.hide()
		option_screen.show()
	else:
		hide()


func _on_bloup_bloup_toggled(toggled_on: bool) -> void:
	bloup_bloup.emit(toggled_on)
	play_sfx()


func _on_music_volume_value_changed(value: float) -> void:
	@warning_ignore("narrowing_conversion")
	Global.music_volume = value


func _on_sfx_volume_value_changed(value: float) -> void:
	@warning_ignore("narrowing_conversion")
	Global.sfx_volume = value


func play_sfx():
	menu_sfx.pitch_scale = randf_range(0.9, 1)
	menu_sfx.play()
