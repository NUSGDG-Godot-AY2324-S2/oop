extends TileMap


func _on_level_1_body_entered(body):
	State.get_instance().set_state(1)


func _on_level_2_body_entered(body):
	State.get_instance().set_state(2)
