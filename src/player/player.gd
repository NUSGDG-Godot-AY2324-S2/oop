extends CharacterBody2D

const SPEED: int = 200
var last_horizontal_direction: int = 0
var last_vertical_direction: int = 0
var horizontal_direction: int = 0
var vertical_direction: int = 0

var animated_sprite: AnimatedSprite2D
var camera: Camera2D

func _ready():
	animated_sprite = $AnimatedSprite2D
	camera = $Camera2D
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
