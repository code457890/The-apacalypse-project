extends Node3D
var time = 0.0
var triggered = false

func _process(delta: float) -> void:
	time += delta
	
	if time >= 10 and not triggered:
		triggered = true
		
		for i in range(1, 3):
			get_child(i).set_item(load("res://grape_seed.tres"))
		
		get_child(3).set_item(load("res://grape.tres"))
