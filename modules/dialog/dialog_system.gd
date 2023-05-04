extends CanvasLayer

@onready var character_name = $ColorRect/name
@onready var text = $ColorRect/text
@onready var voice = $voice

var dialogues = {}

func _ready():
	dialogues = Dialogues.Oskar
	play_dialog()

func _process(delta):
	pass
		
func play_dialog():
	character_name.text = dialogues["name"]
	text.text = dialogues["text"]
	voice.stream = load(dialogues["voice"])
	$voice.play()


