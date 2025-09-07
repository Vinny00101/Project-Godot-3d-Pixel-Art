extends Camera3D

@export var move_speed: float = 10.0  # Velocidade de movimento
@export var mouse_sensitivity: float = 0.2  # Sensibilidade do mouse para rotação
@export var zoom_speed: float = 5.0  # Velocidade do zoom
@export var min_zoom: float = 10.0  # Zoom mínimo (maior fov = mais afastado)
@export var max_zoom: float = 90.0  # Zoom máximo (menor fov = mais próximo)

var velocity: Vector3 = Vector3.ZERO
var yaw: float = 0.0
var initial_position: Vector3
var is_mouse_captured: bool = false

func _ready():
	# Armazenar a posição inicial definida no editor
	initial_position = global_position
	# Inicializar yaw com a rotação Y do editor
	yaw = rotation_degrees.y
	# Capturar o mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	is_mouse_captured = true
	print("Câmera iniciada, posição inicial:", initial_position, " yaw inicial:", yaw)

func _input(event):
	# Rotação horizontal com o mouse
	if event is InputEventMouseMotion and is_mouse_captured:
		yaw -= event.relative.x * mouse_sensitivity
		rotation_degrees = Vector3(-35, yaw, 0)  # Manter ângulo top-down
		print("Rotação: yaw =", yaw)

	# Zoom com a roda do mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			fov = clamp(fov - zoom_speed, min_zoom, max_zoom)
			print("Zoom in, fov =", fov)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			fov = clamp(fov + zoom_speed, min_zoom, max_zoom)
			print("Zoom out, fov =", fov)

	# Alternar captura do mouse com Esc
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		is_mouse_captured = !is_mouse_captured
		print("Mouse capturado:", is_mouse_captured)
		if is_mouse_captured:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var direction: Vector3 = Vector3.ZERO
	# Movimento com WASD
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
		print("Tecla ui_up pressionada")
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
		print("Tecla ui_down pressionada")
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		print("Tecla ui_left pressionada")
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		print("Tecla ui_right pressionada")

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		direction.y = 0  # Garantir movimento apenas no plano XZ
		print("Direção do movimento:", direction)

	# Rotacionar a direção com base no yaw
	direction = direction.rotated(Vector3.UP, deg_to_rad(yaw))
	velocity = direction * move_speed
	# Mover a câmera, preservando a altura inicial
	var new_position = global_position + (velocity * delta)
	new_position.y = initial_position.y
	global_position = new_position
