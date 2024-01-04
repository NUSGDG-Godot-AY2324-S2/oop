extends CharacterBody2D

const MAX_HEALTH: int = 100
var health: int = MAX_HEALTH
var is_taking_damage: bool = false

var animated_sprite: AnimatedSprite2D
var player: CharacterBody2D

var Bullet = preload("res://enemy/bullets/bullet1.tscn")
@export var game_state: int


func _ready():
	animated_sprite = $AnimatedSprite2D
	player = get_parent().get_node("Player")
	if game_state == 0:
		$BulletTimer.start()
	else:
		State.get_instance().state_changed.connect(activate_bullet)


func _physics_process(delta: float):
	adjust_animation()


func adjust_animation():
	if player.position.x >= position.x:
		animated_sprite.scale.x = abs(animated_sprite.scale.x)
	else:
		animated_sprite.scale.x = -abs(animated_sprite.scale.x)


func _on_bullet_timer_timeout():
	var bullet = Bullet.instantiate()
	bullet.set_parameters((player.position - position).normalized(), position)
	get_parent().add_child(bullet)


func take_damage(damage: int):
	health -= damage
	is_taking_damage = true
	$DamageTimer.start()
	if health < 0:
		die()


func die():
	queue_free()


func _on_flash_timer_timeout():
	if is_taking_damage:
		animated_sprite.visible = !animated_sprite.visible


func _on_damage_timer_timeout():
	is_taking_damage = false
	animated_sprite.visible = true


func activate_bullet(state: int):
	if state == self.game_state:
		$BulletTimer.start()
