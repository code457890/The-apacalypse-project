extends CanvasLayer

@onready var background = $background
@onready var grid = $background/Panel/GridContainer
@onready var crafting_grid = $background2/Panel/GridContainer
@onready var crafting = $background2
@onready var selected = $Control

@export var resources: Array[ItemData]

@onready var item = $Control/item
# Preload the slot scene so we can spawn them
var slot_scene = preload("res://slot.tscn")
func _ready():
	background.visible = false
	crafting.visible = false
	selected.visible = true
	# Create slots
	for i in range(16):
		var new_slot = slot_scene.instantiate()
		grid.add_child(new_slot)
		new_slot.get_child(1).crafting_grid = $background2/Panel/GridContainer
	for i in range(5):
		var new_slot = slot_scene.instantiate()
		$background3/HBoxContainer.add_child(new_slot)
		new_slot.get_child(1).crafting_grid = grid
		new_slot.get_child(1).isinventory = true
	for i in range(4):
		var new_slot = slot_scene.instantiate()
		crafting_grid.add_child(new_slot)
		new_slot.get_child(1).crafting_grid = $background3/HBoxContainer
	

func _input(event):
	if event.is_action_pressed("e"): # You need to add this to Input Map!
		toggle_inventory()

func toggle_inventory():
	background.visible = not background.visible
	crafting.visible = not crafting.visible
	selected.visible = not selected.visible
	
	# When inventory is open, show mouse. When closed, lock mouse (for FPS).
	if background.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().call_group("player", "toggle_camera")
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().call_group("player", "toggle_camera")

func craft():
	# Step 1: Count items in the crafting grid
	var grid_counts = {}
	for slot in crafting_grid.get_children():
		var item = slot.get_child(1).item_data
		if item != preload("res://none.tres"):
			grid_counts[item] = grid_counts.get(item, 0) + 1
	
	# Step 2: Check each recipe
	for recipe_item in resources:
		var can_craft = true
		print(recipe_item.name)
		# Count ingredients required for this recipe
		var required_counts = {}
		for ingredient in recipe_item.recipe:
			required_counts[ingredient] = required_counts.get(ingredient, 0) + 1
		
		# Step 3: Make sure grid has enough of each ingredient
		for ingredient in grid_counts.keys():
			print(ingredient.name)
			if required_counts.get(ingredient, 0) != grid_counts[ingredient]:
				can_craft = false
				break
		
		for ingredient in required_counts.keys():
			print(ingredient.name)
			if grid_counts.get(ingredient, 0) != required_counts[ingredient]:
				can_craft = false
				break
		
		# Step 4: Craft the item if possible
		if can_craft:
			print(grid_counts, required_counts)
			# Add the crafted item(s)
			for _i in range(recipe_item.craft_amount):
				add_item(recipe_item, recipe_item.durability)
			
			# Remove ingredients from the inventory/grid
			for ingredient in recipe_item.recipe:
				remove_item(ingredient)
			
			return
func add_item(item_data, dur: int):
	# 1. Check if the function is even triggering
	print("--- STARTING ADD ITEM ---")
	
	# 2. Check if the grid variable exists
		
	# 3. Check if the grid has any slots inside it
	var slots = $background3/HBoxContainer.get_children() + grid.get_children()
	print("Found ", slots.size(), " slots in the grid.")
	
	for slot in slots:
		
		# 4. detailed check of the slot
		if slot.get_child(1).item_data.icon == preload("res://OIP-removebg-preview__3_-removebg-preview.png"):
			print("Found empty slot: ", slot.name)
			slot.get_child(1).set_item(item_data, dur)
			return
		else:
			print("Slot ", slot.name, " is full.")
			
	print("Inventory is full (Loop finished)")
func remove_item(item: ItemData):
	print(item)
		
	# 3. Check if the grid has any slots inside it
	var slots = crafting_grid.get_children()
	print("Found ", slots.size(), " slots in the grid.")
	
	for slot in slots:
		if slot.get_child(1).item_data == item:
			slot.get_child(1).set_item(preload("res://none.tres"), 0)
			return


func _on_button_pressed() -> void:
	craft()
