extends RigidBody3D

@export var item_data : ItemData

func _ready():
	if item_data:
		$Sprite3D.texture = item_data.icon

# This is called by the Player script now!
func pickup():
	# Security Check: Is there actually an item data assigned?
	if item_data == null:
		print("ERROR: This GroundItem has no 'Item Data' assigned in the Inspector!")
		queue_free()
		return # Stop here so we don't crash

	# If we are safe, proceed
	print("Picked up: ", item_data.name)
	
	# Connect to Inventory (See Step 2 below)
	get_tree().call_group("Inventory", "add_item", item_data, item_data.durability)
	
	queue_free()
