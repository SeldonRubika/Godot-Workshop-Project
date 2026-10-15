extends Control
@export var bg_timer: Timer
@export var bg: ColorRect
@export var main_screen: NinePatchRect
@export var option_screen: NinePatchRect

var bg_color := Color("00a17d")

func _process(_delta: float) -> void:
	bg.material.set_shader_parameter("color_1",bg_color)

func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self,"bg_color",Color(randf(),randf(),randf(),1.0),bg_timer.wait_time)

func _on_play_pressed() -> void:
	hide()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	main_screen.hide()
	option_screen.show()

func _on_menu_pressed() -> void:
	main_screen.show()
	option_screen.hide()


func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.option_enable_checkpoint = toggled_on

func _on_attack_mouse_toggled(toggled_on: bool) -> void:
	Global.option_attack_mouse = toggled_on
