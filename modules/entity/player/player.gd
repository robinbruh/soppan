extends CharacterBody3D

#inventory
signal toggle_inventory()
@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip

const SPEED = 5.0
const JUMP_VELOCITY = 2
var health: int = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Get imidiate child neck, camera etc
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var interact_ray = $Neck/Camera3D/InteractRay

func _ready():
	PlayerManager.player = self
	#starts game in captured mode
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	""" TEMPORARILY DISABLED WHILE CREATING INVENTORY
	#Makes mouse invisible & capure
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Makes mouse visible when esc is pressed
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	"""
	#Mouse head mov	ement
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			#Subtract how far the mouse moved in the axisis
			#Relative is mouse position relative to the position in the last frame
			neck.rotate_y(-event.relative.x * 0.0025)
			camera.rotate_x(-event.relative.y * 0.0025)
			#limits neck rotation
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	#inventory
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	
	if Input.is_action_just_pressed("interact"):
		interact()

func _physics_process(delta):
	# Add the gravity. 
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	#the direction should be equal to the necks direction
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	cameraRotation()
	move_and_slide()
	
func cameraRotation():
	var target_rotation = Vector3(0, 0, 0)
	const ROTATION_SPEED = 1
	#remove rotation when both are pressed
	if Input.is_action_pressed("right") && Input.is_action_pressed("left"):
		target_rotation.z = 0
	#Rotate camera based on velocity when moving left/right
	elif Input.is_action_pressed("left"):
		target_rotation.z = 0.25
	elif Input.is_action_pressed("right"):
		target_rotation.z = -0.25
	#if both are pressed
	else:
		target_rotation.z = 0
	#"Inetoeproelate" between rotation target and acutal rotation to not give players whiplash
	neck.rotation.z = lerp_angle(neck.rotation.z, target_rotation.z, ROTATION_SPEED)
	neck.rotation.z = clamp(neck.rotation.z, deg_to_rad(-0.25), deg_to_rad(0.25))

func interact() -> void:
	if interact_ray.is_colliding():
		interact_ray.get_collider().player_interact()


func get_drop_position() -> Vector3:
	var direction = -camera.global_transform.basis.z
	return camera.global_position + direction

func heal(heal_value: int) -> void:
	health += heal_value
