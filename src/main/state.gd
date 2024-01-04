class_name State

var _state: int = 0
signal state_changed

static var instance = State.new()


static func get_instance() -> State:
	return instance


func get_state() -> int:
	return _state


func set_state(state: int):
	self._state = state
	self.state_changed.emit(state)
