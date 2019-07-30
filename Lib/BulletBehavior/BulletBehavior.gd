#BulletBehavior
#Code by: First
 
# The Bullet behavior simply moves parent object forwards at
# an angle. #However, it provides extra options like gravity
# and angle in degrees that allow it to also be used.
# Like the name suggests it is ideal for projectiles like
# bullets, but it is also useful for automatically 
# controlling other types of objects like enemies
# which move forwards continuously.

  ###Usage###
# This will work on any parent node having 'position' property.
# Place it under parent node and start configuring.

tool
extends Node

class_name User_BulletBehavior2D

signal distance_travelled_reached
signal stopped_moving 

enum PROCESS_TYPE {
	IDLE,
	PHYSICS
}

#Whether the behavior is initially enabled or disabled. If disabled,
#it can be enabled at runtime.
export (bool) var active = true

# -Process mode-
#
# The process how the object moves from a chosen behavior:
# - Idle: Update once per frame.
# - Physics: Update and sync with physics.
export(PROCESS_TYPE) var process_mode = 1

#The bullet's initial speed, in pixels per second.
export (float) var speed = 120

#When on, min and max speed will be used.
export (bool) var speed_limit = false

#Minimum speed in pixel per second.
export (float) var min_speed = 0

#Maximum speed in pixel per second.
export (float) var max_speed = 150

#The rate of acceleration for the bullet, in pixels per second per second.
#Zero will keep a constant speed, positive values accelerate, and negative
#values decelerate until a stop (the object will not go in to reverse).
export (float) var acceleration = 0

#The force of gravity, which causes acceleration downwards, in
#pixels per second per second. Zero disables gravity which is useful for
#top-down games. Positive values cause a parabolic path as the bullet
#is bullet down by gravity.
export (float) var gravity = 0

#The maximum force of gravity. If the gravity of the parent is
#above zero, max fall speed will be positive (as what it was).
#And if the gravity of the parent is below zero, max fall speed
#will be used as negative value.
export (float, 0, 9000, 0.1) var max_fall_speed = 900

#Angle in degrees.
#0 = Right, 90 = Down, 180 = Left, 270 = Up
#0 = Right, -90 = Up, -180 = Left, -270 = Down
export (float) var angle_in_degrees = 0.0

#If true, the speed will never go below zero.
export (bool) var allow_negative_speed = false

#Signal on distance travelled by pixels.
#Specified travel value will be used to emit a signal.
export (float) var signal_on_distance_travelled = 500


#Temp variables
var _init_position := Vector2()
var current_acceleration : float = 0
var current_gravity : float = 0
var current_distance_traveled : float = 0
var vec_angle : Vector2
var velocity : Vector2

func _get_configuration_warning() -> String:
	var warning : String
	
	if not "position" in get_parent():
		warning += "This will work only on parent node having 'position' property. "
		warning += "Consider placing it on Node2D or Control as parent node."
	
	return warning

func _ready() -> void:
	var _parent = get_parent()
	_init_position = _parent.get_position()

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): #We want this to works only in-game.
		return
	
	if process_mode == PROCESS_TYPE.IDLE:
		_do_process(delta)
		_check_and_emit_signals()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): #We want this to works only in-game.
		return
	
	if process_mode == PROCESS_TYPE.PHYSICS:
		_do_process(delta)
		_check_and_emit_signals()     

func _do_process(delta: float) -> void:
	var _parent = get_parent()
	if not active:
		return
	
	#Set normalized vector2's angle
	vec_angle = Vector2(cos(deg2rad(angle_in_degrees)), sin(deg2rad(angle_in_degrees)))
	
	#Set movement speed in pixels per second
	var movement = speed + current_acceleration
	#Clamp movement between limits (if on)
	if speed_limit == true:
		movement = clamp(movement, min_speed, max_speed)
	if movement < 0 and not allow_negative_speed:
		movement = 0
	velocity = vec_angle * movement * delta
	
	#Apply gravity
	#Limits current gravity first, then apply to _gravity.
	if current_gravity > 0:
		if current_gravity > max_fall_speed:
			current_gravity = max_fall_speed
	else:
		if current_gravity < -max_fall_speed:
			current_gravity = -max_fall_speed
	var _gravity = Vector2(0, current_gravity) * delta
	
	#Remember current position
	var prev_position = _parent.position
	
	#Start movement.
	_parent.position += velocity + _gravity
	
	#Increment values
	current_acceleration += acceleration * delta
	current_gravity += gravity * delta
	current_distance_traveled += prev_position.distance_to(_parent.position)

#Check all emit-able signals. If there's one that can be emitted,
#start one.
var _is_signal_distance_travelled_reached_emitted : bool = false
var _is_signal_stopped_moving_emitted : bool = false
func _check_and_emit_signals():
	if (current_distance_traveled >= signal_on_distance_travelled and !_is_signal_distance_travelled_reached_emitted):
		emit_signal("distance_travelled_reached")
		_is_signal_distance_travelled_reached_emitted = true
	else:
		_is_signal_distance_travelled_reached_emitted = false
	
	if (velocity == Vector2(0, 0) and !_is_signal_stopped_moving_emitted):
		emit_signal("stopped_moving")
		_is_signal_stopped_moving_emitted = true
	else:
		_is_signal_stopped_moving_emitted = false
