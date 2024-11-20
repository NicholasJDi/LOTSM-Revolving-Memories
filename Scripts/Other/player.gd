class_name player_controller
extends CharacterBody2D

@onready var jump_sfx: AudioStreamPlayer2D = $SFX/jump_sfx
@onready var land_sfx: AudioStreamPlayer2D = $SFX/land_sfx
@onready var walk_sfx_1: AudioStreamPlayer2D = $SFX/walk_sfx/walk_sfx1
@onready var crouch_sfx_1: AudioStreamPlayer2D = $SFX/crouch_sfx/crouch_sfx1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

@export var walk_acceleration = 0
@export var walk_max_speed = 0
@export var crouch_acceleration = 0
@export var crouch_max_speed = 0
@export var jump_force = 0
@export var jump_buffer = 0
@export var can_double_jump = false
@export var double_jump_force = 0
@export var gravity = 0
@export var max_fall_speed = 0
@export var can_move = true

var has_double_jumped = true 
var animation_locked = false
var direction : Vector2 = Vector2.ZERO
var in_air = false

var is_walking = false
var is_crouching = false


func _physics_process(_delta):
	if animated_sprite.animation == "jump_start" and is_on_floor():
		animated_sprite.play("jump_end")
		land_sfx.play()
	if !is_on_floor():
		if can_move and Input.is_action_pressed("jump"):
			velocity.y += (gravity -jump_buffer)
		if not Input.is_action_pressed("jump"):
			velocity.y += gravity
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed
		if not animation_locked:
			jump_animation()
			jump_sfx.play()
	if can_move:
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = -jump_force
				has_double_jumped = false
				jump_animation()
				jump_sfx.play()
			elif can_double_jump:
				if not has_double_jumped: 
					velocity.y = -double_jump_force
					has_double_jumped = true
					jump_animation()
					jump_sfx.play()
		if not ConsoleWindow.has_focus():
			direction = Input.get_vector("move_left", "move_right", "jump", "crouch")
		else:
			direction = Vector2i(0,0)
		if Input.is_action_pressed("crouch"):
			set_collision_mask_value(3, false)
			if direction.x != 0:
				velocity.x += (crouch_acceleration * direction.x)
				if velocity.x > crouch_max_speed:
					velocity.x  = crouch_max_speed
				if velocity.x < -crouch_max_speed:
					velocity.x = -crouch_max_speed
			else:
				velocity.x = 0
		else:
			set_collision_mask_value(3, true)
			if direction.x != 0:
				velocity.x += (walk_acceleration * direction.x)
				if velocity.x > walk_max_speed:
					velocity.x  = walk_max_speed
				if velocity.x < -walk_max_speed:
					velocity.x = -walk_max_speed
			else:
				velocity.x = 0
	move_and_slide()
	update_animation()
	update_animation_direction()


func update_animation():
	if not animation_locked:
		if direction.x != 0:
			if Input.is_action_pressed("crouch"):
				animated_sprite.play("crouch")
				is_walking	 = false
				is_crouching = true
			else:
				animated_sprite.play("walk")
				is_walking	 = true
				is_crouching = false
		else:
			animated_sprite.play("idle")
			is_walking	 = false
			is_crouching = false
			animated_sprite.pause()
			is_walking	 = false
			is_crouching = false

func update_animation_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true


func jump_animation():
	animated_sprite.play("jump_start")
	animation_locked = true


func land_animation():
	animated_sprite.play("jump_end")
	animation_locked = true


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "jump_end":
		animation_locked = false


func _on_timer_timeout():
	if is_on_floor():
		if is_walking:
			walk_sfx_1.play()
		if is_crouching:
			crouch_sfx_1.play()
