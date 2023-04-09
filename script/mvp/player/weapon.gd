extends Node3D
var reloading = false
signal animation_done(ani)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("fire") && reloading == false:
		$AnimationPlayer.play("shoot")
	if Input.is_action_pressed("reload") && reloading == false:
		reloading = true
		$AnimationPlayer.play("reload")
		#Wait timer before allowing reloading again
		await get_tree().create_timer(1.0).timeout
		await reload_reset()

func reload_reset():
	reloading = false
