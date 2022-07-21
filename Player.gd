extends Area2D

signal hit

# How fast the player will move (pixels per second).
export var speed = 400
# Size of the game window.
var screen_size
var movement_vector = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size

	hide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$MobileJoystick.show()

func _process(delta):
	# The player's movement vector.
	var velocity = movement_vector

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body:Node):
	# Player disappears after being hit.
	hide()
	$MobileJoystick.hide()
	emit_signal("hit")

	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)


func _on_MobileJoystick_use_move_vector(move_vector):
	movement_vector = move_vector
	print("joystick is being dragged")


func _on_MobileJoystick_stop_moving():
	movement_vector = Vector2.ZERO
	print("joystick is released")
