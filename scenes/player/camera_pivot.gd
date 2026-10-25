# res://scripts/vehicles/car_camera.gd
class_name CarCamera
extends Node3D

@export_range(1.0, 20.0, 0.1) var follow_smooth_speed: float = 6.0
@export var height_offset: float = 1.8
@export var distance_offset: float = 4.5

var _smoothed_direction: Vector3 = Vector3.FORWARD

func _physics_process(delta: float) -> void:
	var car: VehicleBody3D = get_parent() as VehicleBody3D
	if not car:
		return

	var velocity: Vector3 = car.linear_velocity
	velocity.y = 0.0
	
	# Only update orientation if car is actively rolling to avoid camera spin at zero speed
	if velocity.length_squared() > 1.0:
		var movement_direction: Vector3 = -velocity.normalized()
		_smoothed_direction = _smoothed_direction.slerp(movement_direction, follow_smooth_speed * delta)
	
	global_transform.basis = _get_rotation_from_direction(_smoothed_direction)

func _get_rotation_from_direction(direction: Vector3) -> Basis:
	var normalized_dir: Vector3 = direction.normalized()
	var right_axis: Vector3 = normalized_dir.cross(Vector3.UP).normalized()
	var up_axis: Vector3 = right_axis.cross(normalized_dir).normalized()
	return Basis(right_axis, up_axis, -normalized_dir)
