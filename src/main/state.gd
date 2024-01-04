class_name State

var _state: int = 0
signal state_changed

var _minion_kill_count: int = 0
signal minion_kill_increased

static var instance = State.new()


static func get_instance() -> State:
	return instance


func get_state() -> int:
	return _state


func set_state(state: int):
	self._state = state
	self.state_changed.emit(state)


func add_minion_kill_count():
	_minion_kill_count += 1
	if _minion_kill_count % 2 == 0:
		minion_kill_increased.emit()
