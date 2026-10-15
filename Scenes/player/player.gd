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
var stop_velocity := false
#Life
var max_hp := 100
var hp := max_hp
var i_frames := 10
var temp_i_frames := 0
var invincible := false
#kb
var knockback_power := 6000
var knockback_direction : Vector2 = Vector2.ZERO
var taking_knockback : bool = false
var y_knockback_offset := -100
var reverse_knockback := false
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
		var tempt_y_knockback_offset = y_knockback_offset
		if reverse_knockback:
			tempt_y_knockback_offset *=-1
			tempt_y_knockback_offset /= 2
		velocity = (knockback_direction*knockback_power*delta)+Vector2(0,tempt_y_knockback_offset)
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
	if !stop_velocity:
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func _process(_delta: float) -> void:
	if invincible:
		temp_i_frames +=1
		if temp_i_frames >= i_frames:
			temp_i_frames = 0
			invincible = false
	
	if !atk_animation.is_playing():
		atk_animation.hide()
		if Input.is_action_pressed("Down"):
			if  is_on_floor():
				return
			atk_direction = "down"
			atk_animation.rotation_degrees = 90
			atk_animation.flip_h = false
		elif Input.is_action_pressed("Up"):
			atk_direction = "up"
			atk_animation.rotation_degrees = -90
			atk_animation.flip_h = false
		elif Input.is_action_pressed("Right"):
			atk_direction = "right"
			atk_animation.flip_h = false
			atk_animation.rotation_degrees = 0
		elif Input.is_action_pressed("Left"):
			atk_direction = "left"
			atk_animation.flip_h = true
			atk_animation.rotation_degrees = 0
	if Input.is_action_just_pressed("Attack"):
		hurtbox.position = hurtbox_pos[atk_direction]
		hurtbox.monitoring = true
		atk_animation.show()
		atk_animation.play("atk")
		get_tree().create_timer(.3).timeout.connect(func():hurtbox.monitoring=false)

func _ready() -> void:
	hurtbox.position = hurtbox_pos[atk_direction]
	hurtbox.monitoring = false
	Global.respawn_position = global_position

func reset_coyote_time() -> void:
	coyote_time.stop()
	can_jump = false

func _on_coyote_time_timeout() -> void:
	reset_coyote_time()

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

func _on_hitbox_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if invincible:
		return
	var atk : int = 0
	var kb_enemy_pos : Vector2 = Vector2.ZERO
	if body is TileMapLayer:
		var tile_coord = body.get_coords_for_body_rid(body_rid)
		var tile_data = body.get_cell_tile_data(tile_coord).get_custom_data("atk")
		if body.get_cell_tile_data(tile_coord).get_custom_data("reverse_spike"):
			reverse_knockback = true
		atk = tile_data
		kb_enemy_pos = to_global(body.map_to_local(tile_coord))/2 #i genuinely have no idea why i need to divide by two, but it works
	elif body.is_in_group(&"monster"):
		atk = body.atk
		kb_enemy_pos = body.global_position
	
	if  atk != 0:
		invincible = true
		take_damage(atk)
		knockback_direction = (global_position-kb_enemy_pos).normalized()
		taking_knockback = true
		get_tree().create_timer(.2).timeout.connect(func():
			taking_knockback=false
			reverse_knockback = false)
	


func _on_special_tile_detector_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMapLayer:
		var tile_coord = body.get_coords_for_body_rid(body_rid)
		var tile_data = body.get_cell_tile_data(tile_coord).get_custom_data("jump_power")
		velocity.y -= tile_data
