extends StaticBody3D

func plant(slot_script: Control):
	get_parent().get_parent().plant(slot_script)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
