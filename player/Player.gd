extends KinematicBody

# stats
var health : int = 10
var maxHealth : int = 10

# physics variables
const walkSpeed : float = 4.3
const sprintSpeed : float = 5.6
const jumpForce : float = 9.0
const gravity : float = 32.0

const cameraSensitivity : float = 20.0

# vectors
var velocity : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

onready var camera = $Camera
onready var hitbox = $CollisionShape
	

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# movement
func _physics_process(delta):
	# reset horizontal movement
	velocity.x = 0
	velocity.z = 0
	
	var input = Vector2()
	
	# check movement inputs
	if Input.is_action_pressed("ui_right"):
		input.x += 1
	if Input.is_action_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_pressed("ui_down"):
		input.y += 1
	
	# set magnitude of movement vector to 1
	input = input.normalized()
	
	var direction = (transform.basis.z * input.y + transform.basis.x * input.x)
	
	# set velocity
	velocity.x = direction.x * (walkSpeed if !Input.is_action_pressed("Sprint") else sprintSpeed)
	velocity.z = direction.z * (walkSpeed if !Input.is_action_pressed("Sprint") else sprintSpeed)
	
	#apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# jump
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = jumpForce
	
	# move the player
	velocity = move_and_slide(velocity,Vector3.UP)
	
	#turn with the mouse
	camera.rotation_degrees.x -= mouseDelta.y * cameraSensitivity * delta
	rotation_degrees.y -= mouseDelta.x * cameraSensitivity * delta
	hitbox.global_rotation = Vector3()
	
	
	# limit rotation
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	
	if Input.is_action_pressed("ui_cancel") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	mouseDelta = Vector2()

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative 
	if event is InputEventMouseButton and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
