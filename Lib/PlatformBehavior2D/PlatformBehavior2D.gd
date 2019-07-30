#PlatformBehavior2D
#Code by: First

# The Platform behavior applies the parent node of
# KinematicBody2d a side-view "jump and run" style
# movement. By default the Platform movement is
# controlled by the ui_left and ui_right keys and
# ui_up to jump.

# To set up custom controls, you
# can do so by setting export variables:
#    DEFAULT_CONTROL_LEFT = 'ui_left'
#    DEFAULT_CONTROL_RIGHT = 'ui_right'
#    DEFAULT_CONTROL_JUMP = 'ui_up'
# To set up automatic controls, you can set
# either one of these:
#    simulate_walk_left = true
#    simulate_walk_right = true
#    simulate_jump = true
# While any of the above is true (e.g. 
# simulate_walk_left), the parent node will
# move itself as if it was holding left button.

  ###Usage###
# Instance PlatformBehavior2D (from /Lib) or
# adding child node as
# User_PlatformBehavior2D (PlatformBehavior2D.gd)
# where you want a KinematicBody2D to have this
# behavior enabled. When attached, it's ready
# to be used!

#PROs:
# - No need to attach script and write it over
#   on every KinematicBody2D objects.
# - Can be used on every object that's
#   KinematicBody2D.
#CONs:
# - Quite complex to use.
# - The script is currently very complicated to 
#   understand if you plan to improve it.

tool
extends Node

class_name User_PlatformBehavior2D

#Emits when collided with movement type of
#'Move and Collide' active. This returns
#a KinematicCollision2D, which contains
#information about a collision that occurred
#during the last move_and_collide() call.
signal move_and_collided(kinematic_collision)

#Emits when parent node of KinematicBody2D has
#just landed.
signal landed

#Emits when the parent node just jumped.
signal jumped

#Emits when the parent node just jumped, but
#only emits when jump key is pressed.
signal jumped_by_keypress

#Emits when parent node of KinematicBody2D has
#just hit ceiling.
signal hit_ceiling

#Emits when parent node of KinematicBody2D has
#just by wall.
signal by_wall

#Emits when collided with movement type of
#'Move and Slide' active. This returns
#a KinematicCollision2D, which contains
#information about a collision that occurred
#during the last custom_move_and_slide() call.
signal collided(kinematic_collision_2d)

enum MOVE_TYPE_PRESET {
	MOVE_AND_SLIDE,
	MOVE_AND_COLLIDE
}

#Movement type for parent node of KinematicBody2D
#If it's MOVE_AND_SLIDE, method move_and_slide()
#will be used. If it's MOVE_AND_COLLIDE, method
#move_and_collide() will be used. It's advise to
#leave MOVE_AND_SLIDE default.
export(MOVE_TYPE_PRESET) var move_type = 0

#The force of gravity, which causes acceleration
#by vector's axis, in pixels per second.
#Note that x-axis is not currently supported,
#and should be used with cautions.
export(Vector2) var GRAVITY_VEC = Vector2(0, 900.0) # pixels/second/second

#Movement speed when left/right key is pressed,
#in in pixels per second.
export(float) var WALK_SPEED = 250 # pixels/sec

#Jump force when jump key is pressed.
export(float) var JUMP_SPEED = 360

#--
export(float) var SIDING_CHANGE_SPEED = 10

#--
export(float) var VELOCITY_X_DAMPING = 0.1

#Maximum fall speed, in pixels per second.
export(float) var MAX_FALL_SPEED = 600

#Normalized vector for a KinematicBody2D
#considering as a floor.
export var FLOOR_NORMAL = Vector2(0, -1)

#When off, this will become 'inactive' state.
export(bool) var INITIAL_STATE = true

#If control is disabled, any keypresses or inputs
#will not be used.
export(bool) var CONTROL_ENABLE = true

#Input Actions
export(String) var DEFAULT_CONTROL_LEFT = 'ui_left'
export(String) var DEFAULT_CONTROL_RIGHT = 'ui_right'
export(String) var DEFAULT_CONTROL_JUMP = 'ui_up'

onready var parent : Node = get_parent()

#Temp variables
var velocity = Vector2()
var on_air_time : float = 0
var is_just_landed = true
var is_just_hit_ceiling = false
var is_just_by_wall
#Simulate control where it can be toggled.
#While on, the object will keep moving until toggled off.
var simulate_walk_left = false
var simulate_walk_right = false
var simulate_jump = false
var walk_left = false #Init... once
var walk_right = false #Init... once
var on_floor = true
var on_ceiling = false
var on_wall = false
var jump = false #Init... once
var move_direction : int #-1 = moving left, 1 = moving right, 0 = still.

func _get_configuration_warning() -> String:
	var warning : String
	
	if not get_parent() is KinematicBody2D:
		warning += "This node only works with a KinematicBody2D as parent node. "
		warning += "Please only use it as a child of KinematicBody2D."
	
	return warning

func _physics_process(delta):
	if Engine.is_editor_hint(): #We want this to works only in-game.
		return
	
	#Won't work if parent node is not KinematicBody2D.
	if !is_validate():
		return
	parent = parent as KinematicBody2D
	
	#Check for initial state
	if !INITIAL_STATE:
		return
	
	move_direction = 0
	
	### MOVEMENT ###
	
	# Apply gravity
	velocity += delta * GRAVITY_VEC
	
	# Either Move and slide or Move and collide
	if move_type == MOVE_TYPE_PRESET.MOVE_AND_SLIDE:
		velocity = custom_move_and_slide(velocity, FLOOR_NORMAL)
	elif move_type == MOVE_TYPE_PRESET.MOVE_AND_COLLIDE:
		var kinematic_collision = parent.move_and_collide(GRAVITY_VEC * delta)
		if kinematic_collision != null:
			emit_signal("move_and_collided", kinematic_collision)
	# Detect if we are on floor - only works if called *after* move_and_slide
	on_floor = parent.is_on_floor()
	on_ceiling = parent.is_on_ceiling()
	on_wall = parent.is_on_wall()
	
	#Adds up on-air time while not on floor
	if not on_floor:
		on_air_time += delta
	else:
		on_air_time = 0
	
	#Checks
	if velocity.y > MAX_FALL_SPEED: #Limits fall speeds
		velocity.y = MAX_FALL_SPEED
	if on_floor: #Emit signal on landed once.
		if !is_just_landed:
			is_just_landed = true
			emit_signal("landed")
	else:
		is_just_landed = false
	if on_ceiling: #Emit signal on ceiling once, reset velocity y
		if !is_just_hit_ceiling:
			is_just_hit_ceiling = true
			emit_signal("hit_ceiling")
		
		velocity.y = 0
	else:
		is_just_hit_ceiling = false
	if on_wall: #Emit signal on wall once.
		if !is_just_by_wall:
			is_just_by_wall = true
			emit_signal("by_wall")
	else:
		is_just_by_wall = false
	
	### CONTROL ###
	
	# Horizontal movement
	var target_speed = 0
	walk_left = (Input.is_action_pressed(DEFAULT_CONTROL_LEFT) && CONTROL_ENABLE) || simulate_walk_left
	walk_right = (Input.is_action_pressed(DEFAULT_CONTROL_RIGHT) && CONTROL_ENABLE) || simulate_walk_right
	jump = (Input.is_action_pressed(DEFAULT_CONTROL_JUMP) && CONTROL_ENABLE) || simulate_jump
	if walk_left:
		target_speed -= 1
	if walk_right:
		target_speed += 1

	target_speed *= WALK_SPEED
	velocity.x = lerp(velocity.x, target_speed, VELOCITY_X_DAMPING)

	# Jumping by keypress
	if jump:
		jump_start()
	
	#Move Direction
	#DEV NOTE: Removed check if on_floor.
	if velocity.x < -SIDING_CHANGE_SPEED:
		move_direction = -1
	if velocity.x > SIDING_CHANGE_SPEED:
		move_direction = 1
	

#The same as calling parent: move_and_slide
#This also emit signal the collision's information.
#Sets velocity after move_and_slide() on parent node is called.
func custom_move_and_slide(custom_velocity, custom_floor_normal) -> Vector2:
	var vel = parent.move_and_slide(custom_velocity, custom_floor_normal)
	
	if parent.get_slide_count() > 0:
		for i in parent.get_slide_count():
			emit_signal("collided", parent.get_slide_collision(i))
	
	return vel

#Controls
func jump_start(var check_condition = true) -> void:
	if check_condition:
		if !on_floor:
			return
	
	emit_signal("jumped")
	#Emit signal that the jump is done by keypress.
	if Input.is_action_pressed(DEFAULT_CONTROL_JUMP) && CONTROL_ENABLE:
		emit_signal("jumped_by_keypress")
	
	velocity.y = -JUMP_SPEED

#Check if this node will work. Return false if not.
#An optional parameter can be passed to print for specific errors.
func is_validate() -> bool:
	return parent is KinematicBody2D