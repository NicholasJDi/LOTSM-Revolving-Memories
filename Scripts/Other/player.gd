class_name player_controller
extends CharacterBody2D

# stuff
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var hitbox: CollisionShape2D = $Hitbox

# timers
@onready var death_timer: Timer = $Timers/DeathTimer
@onready var movement_timer: Timer = $Timers/MovementTimer

# sfx
@onready var walk_sfx: AudioStreamPlayer2D = $SFX/Walk
@onready var crouch_sfx: AudioStreamPlayer2D = $SFX/Crouch
@onready var jump_sfx: AudioStreamPlayer2D = $SFX/Jump
@onready var land_sfx: AudioStreamPlayer2D = $SFX/Land

# exports
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
var slide : bool = true
var hight : bool = false
var locked : bool = false
var wall : bool = false
var grab : bool = true


func _ready() -> void:
	camera_2d.position_smoothing_enabled = false
	camera_2d.drag_horizontal_enabled = false
	camera_2d.drag_vertical_enabled = false
	
	position = Vector2(SettingsDataContainer.save_file_data.data.player.location.x, SettingsDataContainer.save_file_data.data.player.location.y)
	camera_2d.zoom = Vector2(SettingsDataContainer.save_file_data.data.player.zoom.x, SettingsDataContainer.save_file_data.data.player.zoom.y)
	checkpoint_pos = Vector2(SettingsDataContainer.save_file_data.data.player.checkpoint.x, SettingsDataContainer.save_file_data.data.player.checkpoint.y)
	current_power_set = SettingsDataContainer.save_file_data.data.player.powers
	
	movement_timer.start(0.1)
	await movement_timer.timeout
	camera_2d.position_smoothing_enabled = true
	camera_2d.drag_horizontal_enabled = true
	camera_2d.drag_vertical_enabled = true

func _process(_delta: float) -> void:
	if not buffer == 6:
		buffer += 1
	if Input.is_action_just_pressed("zoom_in"):
		if not camera_2d.zoom.x == 7:
			camera_2d.zoom.x += 0.5
			camera_2d.zoom.y += 0.5
			SettingsDataContainer.save_file_data.data.player.zoom.x = camera_2d.zoom.x
			SettingsDataContainer.save_file_data.data.player.zoom.y = camera_2d.zoom.y
	if Input.is_action_just_pressed("zoom_out"):
		if not camera_2d.zoom.x == 2:
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
		grab = true
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
		var temp_buffer : float = 0
		if velocity.y > 0:
			temp_buffer += gravity_buffer
		if hight:
			temp_buffer -= jump_bufer
		velocity.y += gravity_force + temp_buffer
	var direction = get_direction()
	
	# wall grab
	if is_on_wall_only() and Input.is_action_pressed("wall_grab") and grab:
		animated_sprite.flip_h = !animated_sprite.flip_h
		grab = false
		wall = true
		animated_sprite.play("wall")
		locked = true
	if is_on_wall_only() and Input.is_action_pressed("wall_grab") and wall:
		velocity.y = 0
		buffer = 5
		jump = true
		double = true
		dash = true
		direction = 0
	if is_on_wall_only() and Input.is_action_just_released("wall_grab") and wall:
		wall = false
		jump = false
		locked = false
		buffer = 6
		if animated_sprite.flip_h:
			velocity.x += -(dash_force / 2)
		else:
			velocity.x += dash_force / 2
	
	# movement
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
		if not locked:
			animated_sprite.play("crouch")
	else:
		if not locked:
			animated_sprite.play("walk")
	if direction == 1:
		animated_sprite.flip_h = false
	elif direction == -1:
		animated_sprite.flip_h = true
	else:
		if not locked:
			animated_sprite.play("idle")
	velocity.x = move_toward(velocity.x, temp_target_speed, temp_acceleration)
	
	# jump
	if not buffer == 6 and Input.is_action_just_pressed("jump") and jump and can_move:
		velocity.y = -jump_force
		jump = false
		hight = true
		if not slide:
			slide = true
			hitbox.position.y == 1
			hitbox.scale.y == 1
		locked = false
		if not is_on_floor():
			wall = false
			if animated_sprite.flip_h:
				velocity.x += -(dash_force / 2)
			else:
				velocity.x += dash_force / 2
		buffer = 5
	
	# double jump
	if not is_on_floor() and Input.is_action_just_pressed("jump") and not jump and double and buffer == 6 and can_move:
		if velocity.y < 0:
			velocity.y += -(jump_force * .75)
		else:
			velocity.y = -(jump_force * .75)
		double = false
		hight = true
		slide = true
		locked = false
	
	# dash
	if not is_on_floor() and Input.is_action_just_pressed("dash") and dash and can_move and not wall:
		if animated_sprite.flip_h:
			velocity.x += -dash_force
		else:
			velocity.x += dash_force
		if velocity.y < 0:
			velocity.y += -(jump_force / 3)
		else:
			velocity.y = -(jump_force / 3)
		dash = false
		slide = true
		locked = false
	
	# slide
	if is_on_floor() and direction != 0 and Input.is_action_just_pressed("slide") and slide and can_move:
		if animated_sprite.flip_h:
			velocity.x += -dash_force
		else:
			velocity.x += dash_force
		velocity.y = (jump_force / 3)
		slide = false
		locked = true
		animated_sprite.play("slide")
	
	# in air
	if not is_on_floor() and not animated_sprite.animation == "jump" and not locked:
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
		velocity.y = max_speed / 2
	if velocity.y < -(max_speed / 2):
		velocity.y = -(max_speed / 2)
	
	move_and_slide()
	SettingsDataContainer.save_file_data.data.player.location.x = position.x
	SettingsDataContainer.save_file_data.data.player.location.y = position.y

func get_direction() -> int:
	if not can_move:
		return 0
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		return -1
	if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		return 1
	return 0

func death():
	invincible = true
	hight = false
	can_move = false
	locked = true
	velocity *= -1
	death_timer.start(2)
	await death_timer.timeout
	velocity.x = 0
	position = checkpoint_pos
	death_timer.start(1)
	await death_timer.timeout
	can_move = true
	invincible = false
	locked = false

func _on_death_hitbox_body_entered(_body: Node2D) -> void:
	if not invincible: death()
func _on_death_hitbox_area_entered(_area: Area2D) -> void:
	if not invincible: death()

func _on_checkpoint_hitbox_area_entered(_area: Area2D) -> void:
	checkpoint_pos = position
	SettingsDataContainer.save_file_data.data.player.checkpoint.x = checkpoint_pos.x
	SettingsDataContainer.save_file_data.data.player.checkpoint.y = checkpoint_pos.y

func _on_animated_sprite_2d_animation_finished() -> void:
	if locked and animated_sprite.animation == "slide":
		slide = true
		locked = false
	if locked and animated_sprite.animation == "wall":
		wall = false
		jump = false
		locked = false
		buffer = 6
		if animated_sprite.flip_h:
			velocity.x += -(dash_force / 4)
		else:
			velocity.x += dash_force / 4
