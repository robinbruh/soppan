extends CanvasLayer

@onready var character_name = $ColorRect/name
@onready var text = $ColorRect/text
@onready var voice = $voice

var dialog
var phrase_num = 0

func _ready():
	dialog = get_dialog()
	assert(dialog, "cp godot, cp godot, cp godot, cp godot")
	play_dialog()
	
func _process(delta):
	if Input.is_action_just_pressed("fire"):
		play_dialog()

func get_dialog(): #skicka in variabel här sen för att hämta rätt json fil
	var dialogPath = "res://modules/dialog/dialogues/test.json"
	var file = FileAccess.open(dialogPath, FileAccess.READ)
	var json = file.get_as_text()
	var output = JSON.parse_string(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		print("cp godot")

func play_dialog():
	if phrase_num >= len(dialog):
		queue_free()
		return
	
	character_name.text = dialog[phrase_num][0]["name"]
	text.text = dialog[phrase_num][0]["text"]
	voice.stream = load(dialog[phrase_num][0]["voice"])
	$voice.play()
	phrase_num += 1
	return


