extends CharacterBody2D

@export var sprite: AnimatedSprite2D

const SPEED = 400.0
const JUMP_VELOCITY = 400.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		if (velocity.y >=0):
			sprite.play("falling")
		else:
			sprite.play("jumping")

	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY
		sprite.play("jumping")

	var direction := Input.get_axis("Go_Left", "Go_Right")
	if direction:
		if is_on_floor():
			sprite.play("run")
		sprite.flip_h = direction < 0
		velocity.x = direction * SPEED *delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*delta)
	if !sprite.is_playing() and is_on_floor():
		sprite.play("default")


	move_and_slide()
