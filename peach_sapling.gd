extends Node3D

var timer: float = 0.0
@onready var tree = load("res://peach_tree.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer >= 10.0:
		var y
		var x = tree.instantiate()
		if x != null:
			var first_child = x.get_child(2)
			if first_child != null:
				y = first_child.get_child(0)
				print(typeof(y))
			else:
				print("First child is null")
		else:
			print("Failed to instantiate tree")
		y.set_script(preload("res://peach_tree.gd"))
		y.max_health = 9
		y.loot_scene = preload("res://ground_item_gravity.tscn")
		y.log_data = preload("res://wood.tres")
		y.leaf_data = preload("res://leaf.tres")
		y.sapling_data = load("res://peach_sapling.tres")
		get_parent().add_child(x)
		queue_free()
