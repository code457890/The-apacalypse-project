# global_xorshift.gd
extends Node

class_name rng

# Xorshift state (must be non-zero)
static var _state: int = 123456789

# Save path
static var _save_path = "user://xorshift_state.save"

# Initialize
static func _static_init():
	# Try to load saved state, otherwise use default
	if not load_state():
		randomize()

# Core Xorshift algorithm
static func next() -> int:
	_static_init()
	# Xorshift algorithm: https://en.wikipedia.org/wiki/Xorshift
	_state ^= _state << 13
	_state ^= _state >> 17
	_state ^= _state << 5
	return _state

# Get random float between 0 and 1
static func randf() -> float:
	return (next() & 0x7FFFFFFF) / 2147483648.0

# Get random integer (full 32-bit range)
static func randi() -> int:
	return next() & 0x7FFFFFFF

# Get random integer in range [min, max] (inclusive)
static func randi_range(min_val: int, max_val: int) -> int:
	return min_val + int(randf() * (max_val - min_val + 1))

# Get random float in range [min, max]
static func randf_range(min_val: float, max_val: float) -> float:
	return min_val + randf() * (max_val - min_val)

# Randomize seed based on time
static func randomize():
	_state = Time.get_unix_time_from_system()
	# Mix it up a bit
	_state ^= _state << 13
	_state ^= _state >> 17
	_state ^= _state << 5
	print('s')

# Set specific seed
static func set_seed(seed_value: int):
	_state = seed_value
	# Ensure non-zero state
	if _state == 0:
		_state = 123456789

# Get current state
static func get_state() -> int:
	return _state

# Save state to user directory
static func save_state() -> bool:
	var file = FileAccess.open(_save_path, FileAccess.WRITE)
	if file:
		file.store_var({
			"state": _state,
			"timestamp": Time.get_unix_time_from_system()
		})
		print("Xorshift state saved to: ", ProjectSettings.globalize_path(_save_path))
		return true
	return false

# Load state from user directory
static func load_state() -> bool:
	if FileAccess.file_exists(_save_path):
		var file = FileAccess.open(_save_path, FileAccess.READ)
		if file:
			var data = file.get_var()
			_state = data["state"]
			print("Xorshift state loaded: ", _state)
			return true
	return false

# Weighted random selection
static func weighted_random(weights: Array) -> int:
	var total = 0.0
	for w in weights:
		total += w
	
	var r = randf() * total
	
	for i in range(weights.size()):
		if r < weights[i]:
			return i
		r -= weights[i]
	
	return weights.size() - 1

# Shuffle array (Fisher-Yates)
static func shuffle(array: Array) -> Array:
	var shuffled = array.duplicate()
	for i in range(shuffled.size() - 1, 0, -1):
		var j = randi_range(0, i)
		var temp = shuffled[i]
		shuffled[i] = shuffled[j]
		shuffled[j] = temp
	return shuffled

# Pick random element from array
static func choice(array: Array):
	if array.size() == 0:
		return null
	return array[randi_range(0, array.size() - 1)]

# Generate normally distributed random number (Box-Muller)
static func randfn(mean: float = 0.0, stddev: float = 1.0) -> float:
	var u1 = randf()
	var u2 = randf()
	var z0 = sqrt(-2.0 * log(u1)) * cos(2.0 * PI * u2)
	return mean + z0 * stddev

# Generate 2D point in circle
static func randf_in_circle(radius: float = 1.0) -> Vector2:
	var angle = randf_range(0, TAU)
	var r = radius * sqrt(randf())
	return Vector2(cos(angle) * r, sin(angle) * r)

# Generate 2D point in rectangle
static func randf_in_rect(rect: Rect2) -> Vector2:
	return Vector2(
		randf_range(rect.position.x, rect.position.x + rect.size.x),
		randf_range(rect.position.y, rect.position.y + rect.size.y)
	)
