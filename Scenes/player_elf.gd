extends CharacterBody2D

@export var player_sprite:AnimatedSprite2D
@export var speed = 300
@export var gravity = 20
@export var jump_strength = 600

@onready var inital_sprite_scale = player_sprite.scale

#subtract right/left to get the direction
func _physics_process(delta: float) -> void:
	var horizontal_input = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	velocity.x = horizontal_input * speed
	velocity.y += gravity
	
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var is_walking = velocity.x != 0 and is_on_floor()
	var is_falling = velocity.y > 0 and not is_on_floor()
	var is_idle = is_on_floor() and velocity.x == 0 
	var is_jump_cancelled = Input.is_action_just_released("jump") and velocity.y < 0
	
	if is_jumping:
		velocity.y -= jump_strength * 1.1
		player_sprite.play("jump")
	elif is_walking:
		player_sprite.play("walk")
	elif is_falling:
		player_sprite.play("fall")
	elif is_idle:
		player_sprite.play("idle")
	#elif is_jump_cancelled:
		#velocity.y -= jump_strength * 1.0

	if not is_zero_approx(horizontal_input):
		if horizontal_input < 0:
			player_sprite.scale = Vector2(-inital_sprite_scale.x, inital_sprite_scale.y)
		else:
			player_sprite.scale = inital_sprite_scale 
	
	move_and_slide()
