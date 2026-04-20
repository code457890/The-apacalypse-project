extends Node3D

@export var tag: String

func plant(slot_script: Control):
	if spawn_item(slot_script.item_data):
		slot_script.set_item(preload('res://none.tres'), 0)
func spawn_item(data):
	if data == preload('res://none.tres'): return false
	if data.type != preload("res://item.gd").Type.plantable: return false
	print(get_child_count())
	if not get_child_count() >= 2 and tag in data.effect.tags:
		var new_item = data.effect.scene.instantiate()
	
		# Add to the world scene (usually the parent of the tree)
		add_child(new_item)
	
		# Set position: Start at tree position + slightly up + random offset
		# This stops them from stacking perfectly on top of each other
		new_item.global_position = global_position
		return true
	return false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
