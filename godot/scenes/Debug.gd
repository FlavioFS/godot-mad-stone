extends CanvasLayer

onready var label : Label = $Label

func on_debug(text):
	label.text = str(text)