extends CharacterBody2D


const SPEED = 10000.0
const JUMP_VELOCITY = -450.0

# Get the gravity from the project settings to be synced with RigidBody nodes.

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jumpTimer = 0.0
var jumpVelocity = 0.0

var direction = 0.0

var run_mod = 1.0

var coyote_time = 0.2
var can_jump = false

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("walk_left", "walk_right")
	
	if is_on_floor() && can_jump == false:
		can_jump = true
	elif can_jump == true && $CoyoteTimer.is_stopped():
		$CoyoteTimer.start(coyote_time)
	
	if Input.is_action_just_pressed("jump") && can_jump:
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("jump") && velocity.y < 0:
		velocity.y = 0

	if(direction < 0):
		animated_sprite.flip_h = true
	elif(direction > 0):
		animated_sprite.flip_h = false
	
	if Input.is_action_pressed("run"):
		run_mod = 2.0
	else:
		run_mod = 1.0

	if Input.is_action_pressed("walk_left"):
		velocity.x = SPEED * -1 * run_mod * delta
		if run_mod == 1:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("run")

	elif Input.is_action_pressed("walk_right"):
		velocity.x = SPEED * run_mod * delta
		if run_mod == 1:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("run")

	if is_on_floor() && not Input.is_action_pressed("walk_left") && not Input.is_action_pressed("walk_right"):
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.x == 0:
			animated_sprite.play("idle")
	elif not is_on_floor():
		if velocity.y > 0:
			animated_sprite.play("fall")
		else:
			animated_sprite.play("jump_up")


	move_and_slide()


func _on_coyote_timer_timeout():
	can_jump = false
	pass # Replace with function body.
