extends StaticBody3D

# Settings
@export var max_health = 8
@export var health = max_health

# LOOT SETTINGS
@export var loot_scene : PackedScene   # Drag 'ground_item.tscn' here
@export var log_data : ItemData        # Drag 'wood.tres' here
@export var leaf_data : ItemData       # NEW: Drag 'leaf.tres' here
@export var sapling_data : ItemData

func hit(healthbar: ProgressBar, item: ItemData):
	if preload("res://item.gd").Type.axe == item.type:
		health -= 2
		if health <= 0:
			chop_down()
		healthbar.max_value = max_health
		healthbar.value = health
		return 1
	elif preload("res://item.gd").Type.other == item.type or preload("res://item.gd").Type.plantable == item.type:
		health -= 1
		if health <= 0:
			chop_down()
		healthbar.max_value = max_health
		healthbar.value = health
		return 0
	else:
		health -= 1
		if health <= 0:
			chop_down()
		healthbar.max_value = max_health
		healthbar.value = health
		return 2

func chop_down():
	# 1. Spawn Wood
	spawn_item(log_data)
	
	
	# 2. Spawn Leaf (Maybe give it a random chance? e.g. 50%)
	if rng.randf_range(0.0, 6.0) > 1.0: spawn_item(leaf_data)
	
	if rng.randf_range(0.0, 10.0) > 1.0: 
		for i in range(rng.randi_range(1,2)):
			spawn_item(sapling_data)
	
	# 3. Destroy Tree
	# (Use get_parent().queue_free() if your script is on the StaticBody inside a Mesh)
	get_parent().get_parent().queue_free() 

# Helper function to keep code clean
func spawn_item(data):
	if data == null: return # Safety check
	
	var new_item = loot_scene.instantiate()
	new_item.item_data = data
	
	# Add to the world scene (usually the parent of the tree)
	get_node('/root/Node3D').add_child(new_item)
	
	# Set position: Start at tree position + slightly up + random offset
	# This stops them from stacking perfectly on top of each other
	var offset = Vector3(randf_range(-0.5, 0.5), 0.25, randf_range(-0.5, 0.5))
	new_item.global_position = global_position + offset

func _ready() -> void:
	sapling_data = load("res://sapling.tres")
