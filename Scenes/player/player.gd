extends CharacterBody2D

@export var sprite: AnimatedSprite2D
@export var coyote_time: Timer

const SPEED := 4000.0
const BASE_GRAVITY_FACTOR := 1.2
const JUMP_VELOCITY := 200.0
const MAX_JUMP_TIME := 0.3
var gravity_factor := 1.0
var jump_time := .2
var can_jump :bool = true
var jump_hold := 1.0

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
		velocity.y = -JUMP_VELOCITY
		gravity_factor = 0.0
		get_tree().create_timer(jump_time).timeout.connect(func(): gravity_factor = 1.0)
		sprite.play("jumping")
		reset_coyote_time()

	var direction := Input.get_axis("Go_Left", "Go_Right")
	if direction:
		if is_on_floor() and sprite.animation == "default":
			sprite.play("run")
		sprite.flip_h = direction < 0
		velocity.x = direction * SPEED *delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*delta)
		if is_on_floor() and sprite.animation == "run":
			sprite.play("default")


	move_and_slide()

func reset_coyote_time() -> void:
	coyote_time.stop()
	can_jump = false

func _on_coyote_time_timeout() -> void:
	reset_coyote_time()
