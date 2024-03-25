extends CharacterBody2D

@export var hp = 25
var speed = 880
signal kaboom
var player_chase = false
var player = null
var animation_lock = false
var explosion_triggered = false
var in_range = false

signal explosion_damage

func _ready():
	$AnimatedSprite2D.play("default")

func _on_sightline_body_entered(body):
	player = body
	if not animation_lock == true:
		$AnimatedSprite2D.play("chase")
	player_chase = true

func _on_sightline_body_exited(body):
	player = null
	if not animation_lock == true:
		$AnimatedSprite2D.play("default")
	player_chase = false
	
func _on_explosion_radius_body_entered(body):
	in_range = true
	
func _on_explosion_radius_body_exited(body):
	in_range = false
	
func _physics_process(delta):
	if player_chase == true:
		
		$NavigationAgent2D.set_target_position(player.global_position) #sets the player as its target position
		#updates every frame
		
		if not $NavigationAgent2D.is_navigation_finished(): #if the enemy hasn't reached the player
			var current_position = get_global_position() #gets own position
			
			var next_path_position = $NavigationAgent2D.get_next_path_position() #gets next position to path to player
			velocity = (next_path_position - current_position).normalized() * speed #calaculates vector to next position
			look_at(next_path_position)
			move_and_slide() #moves using calculated vector		

func _on_detection_radius_body_entered(body):
		speed = 0
		player_chase = false
		if animation_lock == false:
			$AnimatedSprite2D.play("pre_explode")
			$"Explosion_countdown".start()

func _process(delta):
	if hp == 0:
		queue_free()
		
	if explosion_triggered == true:
		if $AnimatedSprite2D.is_playing() == false:
			queue_free()

func _on_tree_exiting():
	remove_from_group("enemy")

func _on_explosion_countdown_timeout():
	if not animation_lock == true:
		$AnimatedSprite2D.play("explode")
		animation_lock = true
	if in_range == true:
		emit_signal("explosion_damage")
	explosion_triggered = true










