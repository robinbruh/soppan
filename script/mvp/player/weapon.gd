extends Node3D

var reloading = false

var damage = 10

const MAX_WEAPON_CAM_SHAKE = 0.025
# Called when the node enters the scene tree for the first time.
@onready var anim_player := $AnimationPlayer
@onready var raycast := $"../../RayCast3D"
@onready var camera := $"../.."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("fire") && reloading == false:
		#Behaviour before shot, raycasts etc, happens once per animation loop
		if not anim_player.is_playing():
			screenshake(true)
			if raycast.is_colliding():
				var target = raycast.get_collider()
				if target.is_in_group("enemy"):
					target.health -= damage
					print("weapon.gd: enemy hit, health:"+str(target.health))
		anim_player.play("shoot")
	else:
		screenshake(false)
	if Input.is_action_pressed("reload") && reloading == false:
		reloading = true
		anim_player.play("reload")
		#Wait for time before setting reloading == false
		await get_tree().create_timer(1.0).timeout
		await reload_reset()

#resets reloading, allows reloading & shooting again
func reload_reset():
	reloading = false

#Screen shake
func screenshake(shake):
	if shake == true:
		camera.position = lerp(camera.position,
			Vector3(randf_range(MAX_WEAPON_CAM_SHAKE, -MAX_WEAPON_CAM_SHAKE),
			randf_range(MAX_WEAPON_CAM_SHAKE, -MAX_WEAPON_CAM_SHAKE), 0), 1)
	if shake == false:
			camera.position = lerp(camera.position, Vector3(), 1)
