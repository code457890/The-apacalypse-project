extends Node3D

var posbiomes = [{'name': 'grass', 'data':load("res://basic_biome.tres")},{'name': 'forest'},{'name': 'river'},{'name': 'cave'},{'name': 'desert'},{'name': 'mountains'},{'name': 'pond'}]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var biomes = [[posbiomes,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null]]
	#for i in range(11):
	#	for j in range(11):
	#		biomes[i][j]=rng.choice(biomes[i][j])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
