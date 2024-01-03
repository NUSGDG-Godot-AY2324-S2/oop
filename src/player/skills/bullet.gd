extends Area2D

var damage: int = 20
var speed: int = 3
var direction: Vector2


func set_parameters(direction: Vector2, position: Vector2):
	self.direction = direction
	self.position = position
	$AnimatedSprite2D.rotation = direction.angle()


func _physics_process(delta: float):
	position += direction * speed


func _on_body_entered(body: CharacterBody2D):
	body.take_damage(damage)
	disappear()


func disappear():
	queue_free()
