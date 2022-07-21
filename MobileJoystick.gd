extends CanvasLayer

signal use_move_vector
signal stop_moving

var move_vector = Vector2.ZERO
var joystick_active = false

func _ready():
	hide()

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $TouchScreenButton.is_pressed():
			move_vector = calculate_move_vector(event.position)
			joystick_active = true
			$Handle.position = event.position
			$Handle.visible = true

	if event is InputEventScreenTouch:
		if event.pressed == false:
			move_vector = Vector2.ZERO
			joystick_active = false
			$Handle.visible = false
			
func _physics_process(delta):
	if joystick_active:
		emit_signal("use_move_vector", move_vector)
	else:
		emit_signal("stop_moving")

func calculate_move_vector(event_position):
	var texture_center = $TouchScreenButton.position + Vector2(64, 64)
	return (event_position - texture_center).normalized()

func hide():
	$TouchScreenButton.hide()
	$Handle.hide()

func show():
	$TouchScreenButton.show()
	$Handle.show()
