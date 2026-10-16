extends Control
@export var achievement_texture: TextureRect
@export var achievement_text: RichTextLabel


func load_achievment(resource: AchievementResource):
	achievement_texture.texture = resource.texture
	achievement_text.text = "[color=yellow]%s![/color]
[font_size=12] %s" % [resource.name, resource.desc]


func show_achievement():
	var tween = create_tween()
	tween.tween_property(self, "anchor_top", 0.84, 1.5)
	tween.parallel().tween_property(self, "anchor_bottom", 0.94, 1.5)
	await get_tree().create_timer(3).timeout
	var new_tween = create_tween()
	new_tween.tween_property(self, "anchor_top", 1.3, 1.5)
	new_tween.parallel().tween_property(self, "anchor_bottom", 1.4, 1.5)


func _ready() -> void:
	load_achievment(preload("uid://ddvov6cotjbi4"))
	show_achievement()
