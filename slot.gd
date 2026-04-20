extends Control # Or whatever your root node is

# 1. DECLARE THE VARIABLE HERE
# This lets the whole script remember which item is in the slot
@onready var item_data : ItemData = preload("res://none.tres")

var crafting_grid: Node = null

var durability: int

var isinventory: bool = false

@onready var icon_visual = get_parent().get_child(0)
@onready var dur_bar = $ProgressBar

func set_item(new_item: ItemData, dur: int):
	print("set"+str(new_item))
	# 2. STORE THE DATA
	item_data = new_item
	dur_bar.value = 0
	dur_bar.max_value = 1
	
	if item_data != preload("res://none.tres"):
		icon_visual.texture = item_data.icon
		tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
		durability = dur
		dur_bar.max_value = item_data.durability
		dur_bar.value = durability
	else:
		icon_visual.texture = preload("res://OIP-removebg-preview__3_-removebg-preview.png")
		tooltip_text = ""
		durability = -2
func _on_gui_input(event):
	# Now this function can see 'item_data' because we declared it at the top
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if item_data != preload("res://none.tres"):
			if not(isinventory && try_to_eat()):
				var crafting = crafting_grid.get_children()
				for i in crafting:
					print(i.get_child(1).item_data.name)
					if i.get_child(1).item_data == preload("res://none.tres"):
						i.get_child(1).set_item(item_data, durability)
						set_item(preload("res://none.tres"), 0)
						return
func try_to_eat(): 
	# Security check: Is this actually food?
	print(item_data.name)
	if item_data.type == preload("res://item.gd").Type.edible:
		print(item_data.name)
		var player = get_tree().get_first_node_in_group("player")
		
		if player:
			var did_eat = player.eat_item(item_data.effect)
			
			if did_eat:
				# Remove item from inventory
				set_item(preload("res://none.tres"), 0)
				return true
	return false
func update_bar():
	dur_bar.value = durability
	dur_bar.max_value = item_data.durability
	if durability <= 0:
		set_item(preload("res://none.tres"), 0) 
