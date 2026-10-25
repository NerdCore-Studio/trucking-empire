extends VehicleBody3D

@export var engine_force_max: float = 300.0
@export var brake_force: float = 3.0
@export var steering_limit: float = 0.6
@export var steering_speed: float = 2.5

var current_steering: float = 0.0

func _physics_process(delta: float) -> void:
	# 转向：平滑逼近目标角度
	var target_steering = Input.get_axis("ui_left", "ui_right") * steering_limit
	current_steering = move_toward(current_steering, target_steering, steering_speed * delta)
	steering = current_steering

	# 油门与刹车
	if Input.is_action_pressed("ui_up"):
		engine_force = engine_force_max
		brake = 0.0
	elif Input.is_action_pressed("ui_down"):
		engine_force = -engine_force_max * 0.6   # 倒车稍慢
		brake = 0.0
	else:
		engine_force = 0.0
		brake = brake_force

	# 手刹（空格）
	if Input.is_action_pressed("ui_accept"):
		brake = brake_force * 3.0
		engine_force = 0.0
