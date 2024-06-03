extends CharacterBody2D

@export var camera_height = -132
@export var camera:PackedScene 
@export var player_sprite:AnimatedSprite2D
@export var speed = 300
@export var gravity = 20
@export var jump_strength = 600

@onready var inital_sprite_scale = player_sprite.scale
var can_double_jump:bool = true
var jump_count:int = 0
var max_jump_count:int = 2
var camera_instance

func _ready() -> void:
	camera_instance = camera.instantiate()
	#camera_instance.global_position.y = camera_height
	get_tree().current_scene.add_child.call_deferred("camera_instance")

func _process(delta: float) -> void:
	camera_instance.global_position.x = global_position.x

#subtract right/left to get the direction
func _physics_process(delta: float) -> void:	
	var horizontal_input = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	velocity.x = horizontal_input * speed
	velocity.y += gravity
	if is_on_floor():
		jump_count = 0
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var is_walking = velocity.x != 0 and is_on_floor()
	var is_falling = velocity.y > 0 and not is_on_floor()
	var is_idle = is_on_floor() and velocity.x == 0 
	var is_jump_cancelled = Input.is_action_just_released("jump") and velocity.y < 0
	var is_double_jumping = Input.is_action_just_pressed("jump") and not is_on_floor() and jump_count < max_jump_count  

	
	if is_jumping:
		velocity.y -= jump_strength * 1.1
		player_sprite.play("jump_start")
		jump_count += 1
	elif is_double_jumping:
		velocity.y = -jump_strength
		can_double_jump = false
		player_sprite.play("double_jump_start")
		jump_count += 1
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


func _on_animated_sprite_2d_animation_finished() -> void:
	player_sprite.play("jump")
	pass # Replace with function body.
