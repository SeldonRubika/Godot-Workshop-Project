extends CharacterBody2D
class_name EnemyBase

@export var sprite: AnimatedSprite2D
@export var death_particles: CPUParticles2D
@export var collision_shape_2d: CollisionShape2D
@export var life: Control
@export var death_sfx: AudioStreamPlayer2D

@export var speed = 4000.0
@export var direction := 1.0
@export var atk := 4

var max_hp := 20
var hp := max_hp
var stop := false

func _ready() -> void:
	life.set_ui_max(max_hp)

func _physics_process(delta: float) -> void:
	death_sfx.volume_linear = Global.sfx_volume *2.3
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	direction = get_direction()
	
	velocity.x = direction * speed * delta
	if !stop:
		move_and_slide()

func get_direction():
	return direction

func take_damage(amount: int):
	hp = min(hp-amount,max_hp)
	life.update_life_ui(hp)
	if hp <=0:
		death_sfx.pitch_scale = randf_range(1.1,1.3)
		death_sfx.play()
		death_particles.emitting = true 
		collision_shape_2d.set_deferred("disabled",true)
		stop = true
		sprite.hide()
		life.hide()
		await death_particles.finished
		queue_free()
	modulate = Color.FIREBRICK
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self,"modulate",Color.WHITE,.2)
