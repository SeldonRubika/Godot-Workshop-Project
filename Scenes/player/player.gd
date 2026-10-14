extends CharacterBody2D
class_name Player

signal took_damage(new_hp:int)
signal death

@export var sprite: AnimatedSprite2D
@export var coyote_time: Timer
@export var hurtbox: Area2D
@export var atk_animation: AnimatedSprite2D

#Movement
const SPEED := 4000.0
const BASE_GRAVITY_FACTOR := 1.2
const JUMP_VELOCITY := 200.0
const MAX_JUMP_TIME := 0.3
var gravity_factor := 1.0
var jump_time := .2
var can_jump :bool = true
var jump_hold := 1.0
#Life
var max_hp := 100
var hp := max_hp
#kb
var knockback_power := 6000
var knockback_direction : Vector2 = Vector2.ZERO
var taking_knockback : bool = false
var y_knockback_offset := -100
#Atk
const hurtbox_pos : Dictionary[String,Vector2] = {
	"up":Vector2(0,-10),
	"down":Vector2(0,14),
	"left":Vector2(-12,2),
	"right":Vector2(12,2),}
var atk_direction := "right"
var atk_power := 10.0

func take_damage(amount: int):
	hp = min(hp-amount,max_hp)
	took_damage.emit(hp)
	if hp <= 0:
		death.emit()
		Global.restart()
	modulate = Color.FIREBRICK
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self,"modulate",Color.WHITE,.2)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if can_jump == true and coyote_time.is_stopped():
			coyote_time.start()
		velocity += get_gravity() * delta * gravity_factor
		if (velocity.y >=0):
			sprite.play("falling")
		else:
			sprite.play("jumping")
	else:
		can_jump = true
	
	#Jump system, increases jump time when holding down jump action
	if Input.is_action_just_pressed("Jump") and can_jump:
		jump_hold = 1.0
	elif Input.is_action_pressed("Jump") and can_jump:
		sprite.play("preparing_to_jump")
		jump_hold += 1*delta
		jump_time = min(MAX_JUMP_TIME,log(jump_hold))
	elif Input.is_action_just_released("Jump") and can_jump:
		jump()
	if taking_knockback:
		velocity = (knockback_direction*knockback_power*delta)+Vector2(0,y_knockback_offset)
	else:
		var direction := Input.get_axis("Left", "Right")
		if direction:
			if is_on_floor() and sprite.animation != "preparing_to_jump":
				sprite.play("run")
			sprite.flip_h = direction < 0
			velocity.x = direction * SPEED *delta
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED*delta)
			if is_on_floor() and sprite.animation != "preparing_to_jump":
				sprite.play("default")
	move_and_slide()

func _process(_delta: float) -> void:
	if !atk_animation.is_playing():
		atk_animation.hide()
		atk_animation.rotation_degrees = 0
		atk_animation.flip_h = false
		if Input.is_action_pressed("Down"):
			atk_direction = "down"
			atk_animation.rotation_degrees = 90
		elif Input.is_action_pressed("Up"):
			atk_direction = "up"
			atk_animation.rotation_degrees = -90
		elif Input.is_action_pressed("Right"):
			atk_direction = "right"
		elif Input.is_action_pressed("Left"):
			atk_direction = "left"
			atk_animation.flip_h = true
	if Input.is_action_just_pressed("Attack"):
		hurtbox.position = hurtbox_pos[atk_direction]
		hurtbox.monitoring = true
		atk_animation.show()
		atk_animation.play("atk")
		get_tree().create_timer(.3).timeout.connect(func():hurtbox.monitoring=false)

func _ready() -> void:
	hurtbox.position = hurtbox_pos[atk_direction]
	hurtbox.monitoring = false

func reset_coyote_time() -> void:
	coyote_time.stop()
	can_jump = false

func _on_coyote_time_timeout() -> void:
	reset_coyote_time()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"monster"):
		take_damage(body.atk)
		knockback_direction = (global_position-body.global_position).normalized()
		taking_knockback = true
		get_tree().create_timer(.2).timeout.connect(func():taking_knockback=false)

func jump():
	velocity.y = -JUMP_VELOCITY
	gravity_factor = 0.0
	get_tree().create_timer(jump_time).timeout.connect(func(): gravity_factor = 1.0)
	sprite.play("jumping")
	reset_coyote_time()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	body.take_damage(atk_power)
	if atk_direction == "down":
		jump_time = randf_range(.18,.22)
		jump()
