class_name player_controller
extends CharacterBody2D


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var camera_2d: Camera2D = $Camera2D

@export var target_speed : float = 250
@export var max_speed : float = 1000
@export var acceleration : float = 25
@export var jump_force : float = 360
@export var gravity_force : float = 30
@export var dash_force : float = 360
@export var jump_bufer : float = 15
@export var gravity_buffer : float = 15
@export var current_power_set : float
@export var checkpoint_pos : Vector2
@export var can_move : bool = true
@export var invincible : bool = false

var double : bool = true
var jump : bool = true
var buffer : int = 0
var dash : bool = true
var hight : bool = false

func _ready() -> void:
	camera_2d.position_smoothing_enabled = false
	camera_2d.drag_horizontal_enabled = false
	camera_2d.drag_vertical_enabled = false
	
	position = Vector2(SettingsDataContainer.save_file_data.data.player.location.x, SettingsDataContainer.save_file_data.data.player.location.y)
	camera_2d.zoom = Vector2(SettingsDataContainer.save_file_data.data.player.zoom.x, SettingsDataContainer.save_file_data.data.player.zoom.y)
	checkpoint_pos = Vector2(SettingsDataContainer.save_file_data.data.player.checkpoint.x, SettingsDataContainer.save_file_data.data.player.checkpoint.y)
	current_power_set = SettingsDataContainer.save_file_data.data.player.powers
	
	timer.start(0.1)
	await timer.timeout
	camera_2d.position_smoothing_enabled = true
	camera_2d.drag_horizontal_enabled = true
	camera_2d.drag_vertical_enabled = true

func _process(_delta: float) -> void:
	if not buffer == 10:
		buffer += 1
	if Input.is_action_just_pressed("zoom_in"):
		if not camera_2d.zoom.x == 7:
			camera_2d.zoom.x += 0.5
			camera_2d.zoom.y += 0.5
			SettingsDataContainer.save_file_data.data.player.zoom.x = camera_2d.zoom.x
			SettingsDataContainer.save_file_data.data.player.zoom.y = camera_2d.zoom.y
	if Input.is_action_just_pressed("zoom_out"):
		if not camera_2d.zoom.x == 1.5:
			camera_2d.zoom.x -= 0.5
			camera_2d.zoom.y -= 0.5
			SettingsDataContainer.save_file_data.data.player.zoom.x = camera_2d.zoom.x
			SettingsDataContainer.save_file_data.data.player.zoom.y = camera_2d.zoom.y

func _physics_process(_delta: float) -> void:
	# reset
	if is_on_floor():
		double = true
		jump = true
		buffer = 0
		dash = true
		velocity.y = 0
	if Input.is_action_just_released("jump"):
		hight = false
	
	# one way ground
	if Input.is_action_pressed("crouch"):
		set_collision_mask_value(3,false)
	else:
		set_collision_mask_value(3,true)
	
	# gravity
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += gravity_force + gravity_buffer
		elif hight:
			velocity.y += gravity_force - jump_bufer
		else:
			velocity.y += gravity_force
	
	# movement
	var direction = get_direction()
	var temp_target_speed = target_speed * direction
	var temp_acceleration = acceleration
	if not is_on_floor():
		if direction != 0:
			temp_acceleration /= 2
		else:
			temp_acceleration /= 4
	if Input.is_action_pressed("crouch"):
		temp_target_speed /= 2
		temp_acceleration /= 2
		animated_sprite.play("crouch")
	else:
		animated_sprite.play("walk")
	if direction == 1:
		animated_sprite.flip_h = false
	elif direction == -1:
		animated_sprite.flip_h = true
	else:
		animated_sprite.play("idle")
	velocity.x = move_toward(velocity.x, temp_target_speed, temp_acceleration)
	
	# jump
	if not buffer == 10 and Input.is_action_just_pressed("jump") and jump and can_move:
		velocity.y = -jump_force
		jump = false
		hight = true
		buffer = 8
	
	# double jump
	if not is_on_floor() and Input.is_action_just_pressed("jump") and double and buffer == 10 and can_move:
		velocity.y = -jump_force - -(jump_force / 4)
		double = false
		hight = true
	
	# dash
	if Input.is_action_just_pressed("dash") and dash and can_move:
		if animated_sprite.flip_h:
			velocity.x += -dash_force
		else:
			velocity.x += dash_force
		if velocity.y < 0:
			velocity.y += -(jump_force / 3)
		else:
			velocity.y = -(jump_force / 3)
		dash = false
	
	
	
	
	
	
	
	
	
	
	
	
	# in air
	if not is_on_floor() and not animated_sprite.animation == "jump":
		animated_sprite.play("jump")
	
	# max speed
	if Input.is_action_pressed("crouch") and can_move:
		var temp_max_speed = target_speed / 2
		if velocity.x > temp_max_speed:
			velocity.x = temp_max_speed
		if velocity.x < -temp_max_speed:
			velocity.x = -temp_max_speed
	else:
		if velocity.x > max_speed:
			velocity.x = max_speed
		if velocity.x < -max_speed:
			velocity.x = -max_speed
	if velocity.y > max_speed / 2:
		velocity.y = max_speed / 2
	if velocity.y < -(max_speed / 2):
		velocity.y = -(max_speed / 2)
	
	move_and_slide()
	SettingsDataContainer.save_file_data.data.player.location.x = position.x
	SettingsDataContainer.save_file_data.data.player.location.y = position.y

func death():
	invincible = true
	can_move = false
	velocity *= -1
	timer.start(2)
	await timer.timeout
	velocity.x = 0
	position = checkpoint_pos
	timer.start(1)
	await  timer.timeout
	can_move = true
	invincible = false

func _on_death_hitbox_body_entered(_body: Node2D) -> void:
	if not invincible: death()
func _on_death_hitbox_area_entered(_area: Area2D) -> void:
	if not invincible: death()

func _on_checkpoint_hitbox_area_entered(_area: Area2D) -> void:
	checkpoint_pos = position
	SettingsDataContainer.save_file_data.data.player.checkpoint.x = checkpoint_pos.x
	SettingsDataContainer.save_file_data.data.player.checkpoint.y = checkpoint_pos.y

func get_direction() -> int:
	if not can_move:
		return 0
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		return -1
	if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		return 1
	return 0
