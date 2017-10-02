extends Control

onready var HalfBody = $HalfBody
onready var FullBody = $FullBody

func _ready():
	HalfBody.hide()
	FullBody.show()