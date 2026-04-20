extends WorldEnvironment

var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta * 4
	var timex
	timex = int(time) % 60
	if timex <= 10:
		environment.fog_light_color = Color.html("#100044")
	elif timex <= 20:
		environment.fog_light_color = Color.html("#153355")
	elif timex <= 30:
		environment.fog_light_color = Color.html("#0066bb")
	elif timex <= 40:
		environment.fog_light_color = Color.html("#0088ff")
	elif timex <= 50:
		environment.fog_light_color = Color.html("#0066bb")
	else:
		environment.fog_light_color = Color.html("#101154")
