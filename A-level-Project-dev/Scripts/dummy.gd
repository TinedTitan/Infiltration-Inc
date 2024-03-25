extends CharacterBody2D

@export var hp = 25

func _process(delta):
	if hp == 0:
		queue_free()
