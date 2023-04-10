extends CharacterBody3D

#health
var health = 100
func health_check():
	if health <= 0:
		queue_free()

#movement
var speed = 3.0
@onready var nav_agent = $NavigationAgent3D
@onready var player = $"../Player"
#target location is set in world.gd in root node3d
func update_target_location(target_location):
	nav_agent.set_target_position(target_location)

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	
	nav_agent.set_velocity(new_velocity)

#update function
func _process(delta):
	health_check()

#Target (player) is reached, setup attack
func _on_navigation_agent_3d_target_reached():
	print("enemy.gd: player in range")

#prevents agents from walking into each other
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	#adds momentum to prevent enemy getting stuck
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()
