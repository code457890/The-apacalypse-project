extends Resource
class_name ItemData

enum Type {
	axe,
	swordspear,
	hoe,
	plantable,
	edible,
	other
}

@export var name: String = ""
@export var description: String = ""
@export var icon: Texture2D
@export var recipe: Array[Resource] = []
@export var craft_amount: Array[Resource] = []
@export var durability: int = 1
@export var type: Type = Type.other
@export var effect: Variant
