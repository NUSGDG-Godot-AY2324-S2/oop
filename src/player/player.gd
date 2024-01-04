extends CharacterBody2D

const SPEED: int = 200
var last_horizontal_direction: int = 0
var last_vertical_direction: int = 0
var horizontal_direction: int = 0
var vertical_direction: int = 0

const MAX_HEALTH: int = 100
var health: int = MAX_HEALTH
var is_taking_damage: bool = false
signal health_changed

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D

const Bullet = preload("res://player/skills/bullet.tscn")
var can_attack: bool = true


func _ready():
	adjust_camera_limits()


func adjust_camera_limits():
	var tilemap: TileMap = get_parent().get_node("Map")
	var rect = tilemap.get_used_rect()
	var cell_size = tilemap.cell_quadrant_size
	camera.limit_left = rect.position.x * cell_size
	camera.limit_right = rect.end.x * cell_size
	camera.limit_top = rect.position.y * cell_size
	camera.limit_bottom = rect.end.y * cell_size


func _physics_process(delta: float):
	make_movement()
	adjust_animation()
	attack()


func make_movement():
	last_horizontal_direction = horizontal_direction
	last_vertical_direction = vertical_direction
	horizontal_direction = Input.get_action_strength("ui_right") \
		- Input.get_action_strength("ui_left")
	vertical_direction = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = Vector2(horizontal_direction, vertical_direction).normalized() * SPEED
	move_and_slide()


func adjust_animation():
	match horizontal_direction:
		0:
			match vertical_direction:
				0:
					play_idle_animation()
				1: 
					attempt_animation("move-down")
				-1:
					attempt_animation("move-up")
		1:
			attempt_animation("move-right")
			animated_sprite.scale.x = abs(animated_sprite.scale.x)
		-1:
			attempt_animation("move-right")
			animated_sprite.scale.x = -abs(animated_sprite.scale.x)


func attack():
	if not Input.is_action_just_pressed("shoot") or not can_attack:
		return
	
	can_attack = false
	$AttackTimer.start()
	
	var direction: Vector2 = (get_global_mouse_position() - position).normalized()
	var bullet = Bullet.instantiate()
	bullet.set_parameters(direction, position)
	get_parent().add_child(bullet)


func play_idle_animation():
	match last_horizontal_direction:
		0:
			match last_vertical_direction:
				1:
					attempt_animation("idle-down")
				-1:
					attempt_animation("idle-up")
		1:
			attempt_animation("idle-right")
			animated_sprite.scale.x = abs(animated_sprite.scale.x)
		-1:
			attempt_animation("idle-right")
			animated_sprite.scale.x = -abs(animated_sprite.scale.x)


func attempt_animation(anim_name: String):
	if animated_sprite.animation != anim_name:
		animated_sprite.play(anim_name)


func take_damage(damage: int):
	if is_taking_damage:
		return
	is_taking_damage = true
	$DamageTimer.start()
	health -= damage
	health_changed.emit(health)
	if health < 0:
		die()


func die():
	queue_free()


func _on_damage_timer_timeout():
	is_taking_damage = false
	animated_sprite.visible = true


func _on_flash_timer_timeout():
	if is_taking_damage:
		animated_sprite.visible = !animated_sprite.visible


func _on_attack_timer_timeout():
	can_attack = true
