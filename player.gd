extends CharacterBody3D

# --- SETTINGS ---
const SPEED = 5.0
const JUMP_VELOCITY = 7.0
const MOUSE_SENSITIVITY = 0.005

# Get gravity
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var cameraOn = true

# Get the Camera (Make sure your camera node is named "Camera3D")
@onready var camera = $Camera3D
@onready var interaction_ray = $Camera3D/RayCast3D  # Adjust path if needed!
# Movement Settings
@export var walk_speed = 5.0
@export var sprint_speed = 10.0
var current_speed = 5.0

# Stamina Settings
@export var max_stamina = 100.0
@export var stamina_drain = 30.0  # How fast it drains per second
@export var stamina_regen = 15.0  # How fast it refills
var current_stamina = 100.0
var stamina_timer = 2.5

var selected: int = 0

# Connect to UI (We will set this up in Step 3)
@export var stamina_bar : ProgressBar

func eat_item(amount):
	if current_stamina >= max_stamina:
		return false # We are full, don't eat it!
	
	current_stamina += amount
	# Clamp it so we don't go over 100
	current_stamina = clamp(current_stamina, 0, max_stamina)
	
	# Update the UI immediately
	if stamina_bar:
		stamina_bar.value = current_stamina
		
	print("Yum! Restored ", amount, " stamina.")
	return true # Successful eating
	
func _ready():
	stamina_bar = get_tree().get_first_node_in_group("Inventory").get_node("ProgressBar")
	# Hide the mouse cursor so you can look around
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func toggle_camera():
	cameraOn = !cameraOn
func _input(event):

	# Mouse look
	if event is InputEventMouseMotion and cameraOn:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)

		camera.rotation.x -= event.relative.y * MOUSE_SENSITIVITY
		camera.rotation.x = clamp(
			camera.rotation.x,
			deg_to_rad(-90),
			deg_to_rad(90)
		)

	# Left click interaction
	if event.is_action_pressed("lc") and cameraOn:
		check_interaction()

func _physics_process(delta):
	var p = Input
	if p.is_action_pressed("1"):
		selected = 0
	elif p.is_action_pressed("2"):
		selected = 1
	elif p.is_action_pressed("3"):
		selected = 2
	elif p.is_action_pressed("4"):
		selected = 3
	elif p.is_action_pressed("5"):
		selected = 4
	var item = get_node("/root/Node3D/CanvasLayer/background3/HBoxContainer").get_child(selected).get_child(1).item_data.icon
	get_tree().get_first_node_in_group("Inventory").item.texture = item if item else preload("res://none.tres").texture
	if not is_on_floor():
		velocity.y -= gravity * delta
	if cameraOn:
	# 1. Check if we are trying to sprint
	# We check: Is Q pressed? AND Is the player actually moving? AND Do we have stamina?
		var is_trying_to_sprint = p.is_action_pressed("q") and velocity.length() > 0
	
	
		if is_trying_to_sprint and current_stamina > 0:
			# SPRINTING
			current_speed = sprint_speed
			current_stamina -= stamina_drain * delta
			stamina_timer = 2.5
		else:
		# WALKING / REGENERATING
			current_speed = walk_speed
		
		# CHECK: Are we actually playing? (Mouse is hidden/captured)
			
			# Only count down timer and regen if the inventory is CLOSED
			if stamina_timer > 0:
				stamina_timer -= delta 
			elif current_stamina < max_stamina:
				current_stamina += stamina_regen * delta
				


	# 2. Clamp Stamina (Keep it between 0 and 100)
		current_stamina = clamp(current_stamina, 0, 100)
	
	# 3. Update the UI Bar (if it exists)
		
	# Add Gravity
		if not is_on_floor():
			velocity.y -= gravity * delta
	# Jump (using default "ui_accept" usually Spacebar)
	# You can change this to "jump" if you added it to Input Map
		if p.is_action_just_pressed(" ") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction using YOUR CUSTOM INPUT NAMES
		var input_dir = p.get_vector("w", "s", "d", "a")
	
		# Calculate direction
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
		if direction:
			velocity.x = direction.x * current_speed
			velocity.z = direction.z * current_speed
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
	if stamina_bar:
		stamina_bar.value = current_stamina


func check_interaction():
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		var vector: Vector3 = interaction_ray.get_collision_point()
		if collider != null:
			if collider is CollisionShape3D:
				collider = collider.get_parent()
			# Priority 1: Pick up items
			if collider.has_method("pickup"):
				collider.pickup()
				print('h')
			# Priority 2: Chop trees / Hit enemies
			elif collider.has_method("hit"):
				var item = get_node("/root/Node3D/CanvasLayer/background3/HBoxContainer").get_child(selected).get_child(1)
				var data = get_node("/root/Node3D/CanvasLayer/background3/HBoxContainer").get_child(selected).get_child(1).item_data
				print(data.name, 'h')
				item.durability -= collider.hit(get_tree().get_first_node_in_group("Inventory").get_child(5), data)
				item.update_bar()
			elif collider.has_method("plant"):
				print('h')
				collider.plant(get_node("/root/Node3D/CanvasLayer/background3/HBoxContainer").get_child(selected).get_child(1))
			else: get_node("/root/Node3D/CanvasLayer/background3/HBoxContainer").get_child(selected).get_child(1).try_to_eat()
		else: get_node("/root/Node3D/CanvasLayer/background3/HBoxContainer").get_child(selected).get_child(1).try_to_eat()
	else: get_node("/root/Node3D/CanvasLayer/background3/HBoxContainer").get_child(selected).get_child(1).try_to_eat()
