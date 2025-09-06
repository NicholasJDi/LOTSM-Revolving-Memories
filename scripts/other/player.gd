class_name PlayerCharacter
extends CharacterBody2D

# stuff
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var ui: CanvasLayer = $Camera2D/UI
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var right_wall_grab_hitbox: Area2D = $Hitbox/Right_Wall_Grab_Hitbox
@onready var left_wall_grab_hitbox: Area2D = $Hitbox/Left_Wall_Grab_Hitbox
# timers
@onready var death_timer: Timer = $Timers/DeathTimer
@onready var movement_timer: Timer = $Timers/MovementTimer
@onready var wall_grab_timer: Timer = $Timers/WallGrabTimer
@onready var slide_timer: Timer = $Timers/SlideTimer

# exports
@export var target_speed : float = 235
@export var max_speed : float = 1000
@export var acceleration_force : float = 25
@export var jump_force : float = 320
@export var gravity_force : float = 30
@export var dash_force : float = 345
@export var jump_force_buffer : float = 15
@export var gravity_force_buffer : float = 15
@export var wall_grab_time_limit : float = 1.3
@export var max_double_jumps : int = 1
@export var current_power_set : int = 1
@export var checkpoint_pos : Vector2
@export var can_move : bool = true
@export var invincible : bool = false
@export var frozen : bool = false

var double_jump_count : int = 0
var can_jump : bool = true
var jump_buffer : int = 0
var can_dash : bool = true
var can_slide : bool = true
var slide_count_idk : int = 0
var extra_jump_hight : bool = false
var animation_locked : bool = false
var is_wall_grabbing : bool = false
var can_wall_grab : bool = true

func _ready() -> void:
	position = Vector2(GameManager.data.player.location.x, GameManager.data.player.location.y)
	camera_2d.zoom = Vector2(GameManager.data.player.zoom.x, GameManager.data.player.zoom.y)
	checkpoint_pos = Vector2(GameManager.data.player.checkpoint.x, GameManager.data.player.checkpoint.y)
	current_power_set = GameManager.data.player.power_set
	
	movement_timer.start(0.1)
	await movement_timer.timeout
	camera_2d.position_smoothing_enabled = true
	camera_2d.drag_horizontal_enabled = true
	camera_2d.drag_vertical_enabled = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		if not camera_2d.zoom.x == 5:
			camera_2d.zoom.x += 0.5
			camera_2d.zoom.y += 0.5
			GameManager.data.player.zoom.x = camera_2d.zoom.x
			GameManager.data.player.zoom.y = camera_2d.zoom.y
	if Input.is_action_just_pressed("zoom_out"):
		if not camera_2d.zoom.x == 2:
			camera_2d.zoom.x -= 0.5
			camera_2d.zoom.y -= 0.5
			GameManager.data.player.zoom.x = camera_2d.zoom.x
			GameManager.data.player.zoom.y = camera_2d.zoom.y

func _physics_process(_delta: float) -> void:
	# jump buffer
	if not jump_buffer == 6:
		jump_buffer += 1
	
	# reset
	if is_on_floor():
		double_jump_count = max_double_jumps
		can_jump = true
		jump_buffer = 0
		can_dash = true
		can_wall_grab = true
		velocity.y = 0
	if Input.is_action_just_released("jump"):
		extra_jump_hight = false
	
	# one way ground
	if Input.is_action_pressed("crouch"):
		set_collision_mask_value(3,false)
	else:
		set_collision_mask_value(3,true)
	
	# gravity
	if not is_on_floor():
		var temp_force_buffer : float = 0
		if velocity.y > 0:
			temp_force_buffer += gravity_force_buffer
		if extra_jump_hight:
			temp_force_buffer -= jump_force_buffer
		velocity.y += gravity_force + temp_force_buffer
	var direction = get_direction()
	var wall_grab = get_wall()
	
	# wall grab
	if is_on_wall_only() and wall_grab != 0 and Input.is_action_pressed("wall_grab") and can_wall_grab and can_move:
		if current_power_set == 0 or current_power_set == 1:
			if wall_grab == -1:
				animated_sprite.flip_h = false
			elif wall_grab == 1:
				animated_sprite.flip_h = true
			can_wall_grab = false
			is_wall_grabbing = true
			animated_sprite.play("wall")
			wall_grab_timer.start(wall_grab_time_limit)
			animation_locked = true
	if is_on_wall_only() and Input.is_action_pressed("wall_grab") and is_wall_grabbing:
		velocity.y = 0
		jump_buffer = 5
		can_jump = true
		double_jump_count = 1
		can_dash = true
		direction = 0
	if is_on_wall_only() and not Input.is_action_pressed("wall_grab") and is_wall_grabbing:
		is_wall_grabbing = false
		jump_buffer = 6
		animation_locked = false
		if animated_sprite.flip_h:
			velocity.x += -(dash_force / 2)
		else:
			velocity.x += dash_force / 2
	
	# movement
	var temp_target_speed = target_speed * direction
	var temp_acceleration_force = acceleration_force
	if not is_on_floor():
		if direction != 0:
			temp_acceleration_force /= 2
		else:
			temp_acceleration_force /= 4
	if Input.is_action_pressed("crouch"):
		if is_on_floor():
			temp_target_speed /= 2
			temp_acceleration_force /= 2
		if not animation_locked:
			animated_sprite.play("crouch")
	else:
		if not animation_locked:
			animated_sprite.play("walk")
	if direction == 1:
		animated_sprite.flip_h = false
	elif direction == -1:
		animated_sprite.flip_h = true
	elif not animation_locked:
		animated_sprite.play("idle")
	if velocity.x == 0 and not animation_locked:
		animated_sprite.play("idle")
	velocity.x = move_toward(velocity.x, temp_target_speed, temp_acceleration_force)
	
	# jump
	if not jump_buffer == 6 and Input.is_action_just_pressed("jump") and can_jump and can_move:
		velocity.y = -jump_force
		can_jump = false
		extra_jump_hight = true
		if not can_slide:
			can_slide = true
		animation_locked = false
		if not is_on_floor():
			wall_grab_timer.stop()
			is_wall_grabbing = false
			if animated_sprite.flip_h:
				velocity.x += -(dash_force / 2)
			else:
				velocity.x += dash_force / 2
		jump_buffer = 5
	
	# double jump
	if not is_on_floor() and Input.is_action_just_pressed("jump") and not can_jump and double_jump_count != 0 and jump_buffer == 6 and can_move:
		if current_power_set == 0 or current_power_set == 2:
			velocity.y = -(jump_force * .75)
			double_jump_count -= 1
			extra_jump_hight = true
			can_slide = true
			animation_locked = false
	
	# dash
	if not is_on_floor() and Input.is_action_just_pressed("dash") and can_dash and double_jump_count < max_double_jumps and not is_wall_grabbing and can_move:
		if current_power_set == 0 or current_power_set == 2:
			if animated_sprite.flip_h:
				velocity.x += -(dash_force * .85)
			else:
				velocity.x += dash_force * .85
			velocity.y = -(jump_force / 2)
			can_dash = false
			can_slide = true
			animation_locked = false
	# slide
	if is_on_floor() and direction != 0 and velocity.x != 0 and Input.is_action_just_pressed("slide") and can_slide and can_move:
		if current_power_set == 0 or current_power_set == 1:
			if animated_sprite.flip_h:
				velocity.x += -dash_force
			else:
				velocity.x += dash_force
			velocity.y = (jump_force / 3)
			can_slide = false
			animation_locked = true
			set_collision_mask_value(4,false)
			animated_sprite.play("slide")
			slide_timer.start(.25)
			slide_count_idk = 0
	
	# in air
	if not is_on_floor() and animated_sprite.animation != "jump" and not animation_locked:
		animated_sprite.play("jump")
	
	# max speed
	if Input.is_action_pressed("crouch") and can_move:
		if velocity.x > max_speed / 2:
			velocity.x = max_speed / 2
		if velocity.x < -(max_speed / 2):
			velocity.x = -(max_speed / 2)
	else:
		if velocity.x > max_speed:
			velocity.x = max_speed
		if velocity.x < -max_speed:
			velocity.x = -max_speed
	if velocity.y > max_speed / 2:
		velocity.y = max_speed / 	2
	if velocity.y < -(max_speed / 2):
		velocity.y = -(max_speed / 2)
	
	# frozen
	if frozen:
		velocity = Vector2.ZERO
	
	move_and_slide()
	GameManager.data.player.location.x = position.x
	GameManager.data.player.location.y = position.y

func get_direction() -> int:
	if not can_move:
		return 0
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		return -1
	if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		return 1
	return 0

func get_wall() -> int:
	if left_wall_grab_hitbox.get_overlapping_bodies().size() != 0 and not right_wall_grab_hitbox.get_overlapping_bodies().size() != 0:
		return -1
	if right_wall_grab_hitbox.get_overlapping_bodies().size() != 0 and not left_wall_grab_hitbox.get_overlapping_bodies().size() != 0:
		return 1
	return 0

func death():
	invincible = true
	extra_jump_hight = false
	can_move = false
	animation_locked = true
	velocity *= -1
	death_timer.start(2)
	await death_timer.timeout
	velocity.x = 0
	position = checkpoint_pos
	death_timer.start(1)
	await death_timer.timeout
	can_move = true
	invincible = false
	animation_locked = false

func _on_death_hitbox_body_entered(_body: Node2D) -> void:
	if not invincible: death()
func _on_death_hitbox_area_entered(_area: Area2D) -> void:
	if not invincible: death()

func _on_checkpoint_hitbox_area_entered(area: Area2D) -> void:
	checkpoint_pos = area.position
	GameManager.data.player.checkpoint.x = checkpoint_pos.x
	GameManager.data.player.checkpoint.y = checkpoint_pos.y

func _on_wall_grab_timer_timeout() -> void:
	is_wall_grabbing = false
	can_jump = false
	animation_locked = false
	jump_buffer = 5
	if animated_sprite.flip_h:
		velocity.x += -(dash_force / 4)
	else:
		velocity.x += dash_force / 4

func _on_slide_timer_timeout() -> void:
	slide_count_idk += 1
	if slide_count_idk == 1:
		animation_locked = false
		slide_timer.start(.5)
	elif slide_count_idk == 2:
		can_slide = true
		slide_timer.stop()
