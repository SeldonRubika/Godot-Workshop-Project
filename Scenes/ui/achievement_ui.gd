@tool
extends Control

@export var achievement_texture: TextureRect
@export var achievement_text: RichTextLabel
@export var resource: AchievementResource
var showing_achievement_tooltip := false
@export var tooltip: Panel


func load_achievment(resource: AchievementResource):
	achievement_texture.texture = resource.texture
	if resource.acquired:
		achievement_texture.z_index = 0
	else:
		achievement_texture.z_index = -1
	achievement_text.text = "[color=yellow]%s![/color]
%s" % [resource.name, resource.desc]


func _process(_delta: float) -> void:
	tooltip.visible = showing_achievement_tooltip
	if resource.acquired:
		load_achievment(resource)


func _ready() -> void:
	load_achievment(resource)


func _on_mouse_entered() -> void:
	showing_achievement_tooltip = true


func _on_mouse_exited() -> void:
	showing_achievement_tooltip = false
