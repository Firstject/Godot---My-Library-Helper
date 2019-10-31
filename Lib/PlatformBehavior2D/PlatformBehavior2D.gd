# PlatformBehavior2D
# Written by: First

tool #Used for configuration warnings.
extends Node

class_name User_PlatformBehavior2D, "./PlatformBehavior.png"

"""
	The Platform behavior applies the root node of
	KinematicBody2d a side-view 'jump and run' style
	movement. By default the Platform movement is
	controlled by the ui_left and ui_right keys and
	ui_up to jump.
	
	To set up custom controls, you
	can do so by setting export variables:
	- default_control_left = 'ui_left'
	- default_control_right = 'ui_right'
	- default_control_jump = 'ui_up'
	
	To set up automatic controls, you can set
	either one of these:
	- simulate_walk_left = true
	- simulate_walk_right = true
	- simulate_jump = true
	
	While any of the above is true (e.g. simulate_walk_left),
	the root node will move itself as if it was holding
	left button.
	
	**Usage**
	
	Instance PlatformBehavior2D (from /Lib) or adding child node as
	FJ_Inst_PlatformBehavior2D (PlatformBehavior2D.gd) and specify
	the target KinematicBody2D node to have this behavior enabled.
	
	**PROs:**
	
	- No need to attach script and write it over on every
	KinematicBody2D objects.
	
	- Can be used on every object that's KinematicBody2D.
	
	**CONs:**
	
	- Quite complex to use.
	
	- The script is currently very complex to use if you plan
	to improve it.
"""

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#Emits when collided with movement type of
#'Move and Collide' active. This returns
#a KinematicCollision2D, which contains
#information about a collision that occurred
#during the last move_and_collide() call.
signal move_and_collided(kinematic_collision)

#Emits when root node of KinematicBody2D has
#just landed.
signal landed

#Emits when the root node just jumped.
signal jumped

#Emits when the root node just jumped, but
#only emits when jump key is pressed.
signal jumped_by_keypress

#Emits when root node of KinematicBody2D has
#just hit ceiling.
signal hit_ceiling

#Emits when root node of KinematicBody2D has
#just by wall.
signal by_wall

#Emits when collided with movement type of
#'Move and Slide' active. This returns
#a KinematicCollision2D, which contains
#information about a collision that occurred
#during the last custom_move_and_slide() call.
signal collided(kinematic_collision_2d)



#-------------------------------------------------
#      Constants
#-------------------------------------------------

#Type at which the method will be used on root node.
enum MovementType {MOVE_AND_SLIDE, MOVE_AND_COLLIDE}

#Type during the processing step of the main loop.
enum ProcessType {IDLE, PHYSICS}

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#The node you want to have this behavior applied.
export (NodePath) var root_node : NodePath = "./.."

#If false, the behavior is in disabled state and won't do anything.
export (bool) var active := true

#The process how the object moves from a chosen behavior:
#
#- Idle: Update once per frame.
#
#- Physics: Update and sync with physics.
export (ProcessType) var process_mode = ProcessType.PHYSICS

#Movement type for root node of KinematicBody2D.
#If it's MOVE_AND_SLIDE, method move_and_slide() on root node will be used.
#If it's MOVE_AND_COLLIDE, method move_and_collide() on root node will be used.
#It's advise to leave MOVE_AND_SLIDE as default.
export (MovementType) var move_type := MovementType.MOVE_AND_SLIDE

#The force of gravity, which causes acceleration
#by vector's axis, in pixels per second.
#Note that x-axis is not currently supported,
#and should be used with cautions.
export (Vector2) var gravity := Vector2(0, 900.0) # pixels/second/second

#Movement acceleration speed when moving left or right,
#in in pixels per second.
export (float) var walk_speed := 250.0

#Friction value at which the target root node is not accelerating.
export (float) var walk_friction := 0.1

#Jump force when jump key is pressed.
export (float) var jump_speed := 360.0

#Offset at which when the state of `move_direction` will change.
export (float) var siding_change_vel := 10.0

#Used in custom_move_and_slide()
export (bool) var stop_on_slope := false

#Used in custom_move_and_slide()
export (int) var max_slides := 3

#Maximum fall speed, in pixels per second.
export (float) var max_fall_speed := 300.0

#Normalized vector for a KinematicBody2D considering as a floor.
export (Vector2) var floor_normal := Vector2(0, -1)

#While the character is standing on the floor, it will try to remain
#snapped to it. If no longer on ground, it will not try to snap again
#until it touches down.
#The snap property is a simple vector pointing towards a direction
#and length (how long it should try to search for the ground to snap)
export (Vector2) var snap_floor_pixel := Vector2(0, 6)

#If false, any keypress or inputs will be disabled.
export (bool) var control_enable := false

#Default action key for a controlled movement of move left.
export(String) var default_control_left = 'ui_left'

#Default action key for a controlled movement of move right.
export(String) var default_control_right = 'ui_right'

#Default action key for a controlled movement of jump.
export(String) var default_control_jump = 'ui_up'


onready var _fetched_root_node : Node = get_node(root_node)


#Current velocity reported after move_and_slide or
#move_and_collided on root node called.
#Note that if you want to get velocity report before
#move_and_slide or move_and_collide calls, use
#velocity_before_move_and_slide instead.
var velocity = Vector2() setget set_velocity, get_velocity

#Time in seconds since leaving the ground.
var on_air_time : float = 0

#True if the root node is just landed.
var is_just_landed = true

#True if the root node is just hit ceiling.
var is_just_hit_ceiling = false

#True if the root node is just by wall.
var is_just_by_wall = false

#Simulate control where it can be toggled.
#While on, the object will keep moving until toggled off.
var simulate_walk_left = false

#Simulate control where it can be toggled.
#While on, the object will keep moving until toggled off.
var simulate_walk_right = false

#Simulate control where it can be toggled.
#While on, the object will keep jumping until toggled off.
var simulate_jump = false

#State at which the target root node is moving left.
#This is automatically set and you should not set this manually.
var walk_left = false #Init... once

#State at which the target root node is moving right.
#This is automatically set and you should not set this manually.
var walk_right = false #Init... once

#State at which the target root node is currently on floor.
#This is automatically set and you should not set this manually.
var on_floor = true

#State at which the target root node is currently on ceiling.
#This is automatically set and you should not set this manually.
var on_ceiling = false

#State at which the target root node is currently by wall.
#This is automatically set and you should not set this manually.
var on_wall = false

#State at which the target root node is jumping such as by keypress.
#You should not set this manually.
var jump = false #Init... once

#Move direction according to moving velocity.
#Negative value indicates the root node is moving left and positive
#indicates the root node is moving right, while zero value indicates
#that no movement is detected.
#`siding_change_vel` is used for offseting before this state changes.
var move_direction : int #-1 = moving left, 1 = moving right, 0 = still.

#Velocity before move_and_slide or move_and_collide is called.
#Useful if you want to get velocity report when landed, hit by wall,
#or hit by ceiling.
#Note that the variable name was changed. So you might want to use
#get_velocity_before_move_and_slide() instead.
var velocity_before_move_and_slide := Vector2() setget ,get_velocity_before_move_and_slide


#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _get_configuration_warning() -> String:
	var warning : String = ""
	
	if not get_node(root_node) is KinematicBody2D:
		warning += "This node only works with a KinematicBody2D as root node. "
		warning += "Please only use it as a child of KinematicBody2D."
	
	return warning

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): #We want this to works only in-game.
		return
	
	if process_mode == ProcessType.IDLE:
		_do_process(delta)

func _physics_process(delta : float) -> void:
	if Engine.is_editor_hint(): #We want this to works only in-game.
		return
	
	if process_mode == ProcessType.PHYSICS:
		_do_process(delta)


#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#The same as calling root node: move_and_slide.
#This also emit signal the collision's information.
#Sets velocity after move_and_slide() on root node is called.
#Note that this is called every frame when this node is active.
#If you wish to call this method manually, make sure to set `active`
#to false.
func custom_move_and_slide(custom_velocity, custom_floor_normal, custom_stop_on_slope = stop_on_slope, custom_max_slides = max_slides) -> Vector2:
	var vel : Vector2
	
	#Make sure to disable snap when the character jumps.
	#Jumping is usually done by setting velocity.y to
	#a negative velocity (like -100), but if snapping
	#is active this will not work, as the character will
	#snap back to the floor.
	if jump and on_floor:
		vel = _fetched_root_node.move_and_slide(custom_velocity, custom_floor_normal, custom_stop_on_slope, custom_max_slides)
	else:
		vel = _fetched_root_node.move_and_slide_with_snap(custom_velocity, snap_floor_pixel, custom_floor_normal, custom_stop_on_slope, custom_max_slides)
	
	if _fetched_root_node.get_slide_count() > 0:
		for i in _fetched_root_node.get_slide_count():
			emit_signal("collided", _fetched_root_node.get_slide_collision(i))
	
	return vel

#Instantly moves an object upward.
#By default jumping must met the conditions such as when on ground.
#Passing an optional parameter of boolean to bypass this.
func jump_start(var check_condition = true) -> void:
	if check_condition:
		if !on_floor:
			return
	
	emit_signal("jumped")
	#Emit signal that the jump is done by keypress.
	if Input.is_action_pressed(default_control_jump) && control_enable:
		emit_signal("jumped_by_keypress")
	
	velocity.y = -jump_speed

#Check if this node will work. Return false if not.
func is_root_node_valid() -> bool:
	return _fetched_root_node is KinematicBody2D

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _do_process(delta : float) -> void:
	if Engine.is_editor_hint(): #We want this to works only in-game.
		return
	
	#Won't work if root node node is not KinematicBody2D.
	if !is_root_node_valid():
		return
	_fetched_root_node = _fetched_root_node as KinematicBody2D
	
	#Check for initial state
	if !active:
		return
	
	move_direction = 0
	
	### MOVEMENT ###
	
	# Apply gravity
	velocity += delta * gravity
	
	# Either Move and slide or Move and collide
	if move_type == MovementType.MOVE_AND_SLIDE:
		#Set velocity before move and slide. For more info,
		#please see its variable.
		set_velocity_before_move_and_slide(velocity)
		velocity = custom_move_and_slide(velocity, floor_normal, stop_on_slope, max_slides)
	elif move_type == MovementType.MOVE_AND_COLLIDE:
		var kinematic_collision = _fetched_root_node.move_and_collide(gravity * delta)
		if kinematic_collision != null:
			emit_signal("move_and_collided", kinematic_collision)
	# Detect if we are on floor - only works if called *after* move_and_slide
	on_floor = _fetched_root_node.is_on_floor()
	on_ceiling = _fetched_root_node.is_on_ceiling()
	on_wall = _fetched_root_node.is_on_wall()
	
	#Adds up on-air time while not on floor
	if not on_floor:
		on_air_time += delta
	else:
		on_air_time = 0
	
	#Checks
	if velocity.y > max_fall_speed: #Limits fall speeds
		velocity.y = max_fall_speed
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
	var walk_dir : int
	walk_left = (Input.is_action_pressed(default_control_left) && control_enable) || simulate_walk_left
	walk_right = (Input.is_action_pressed(default_control_right) && control_enable) || simulate_walk_right
	jump = (Input.is_action_pressed(default_control_jump) && control_enable) || simulate_jump
	if walk_left:
		walk_dir = -1
	if walk_right:
		walk_dir = 1
	
	velocity.x = lerp(velocity.x, walk_dir * walk_speed, walk_friction * delta * 60)
	
	# Jumping by keypress
	if jump:
		jump_start()
	
	#Move Direction
	#DEV NOTE: Removed check if on_floor.
	if velocity.x < -siding_change_vel:
		move_direction = -1
	if velocity.x > siding_change_vel:
		move_direction = 1

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_velocity(val : Vector2) -> void:
	velocity = val

func get_velocity() -> Vector2:
	return velocity

func set_velocity_before_move_and_slide(val : Vector2) -> void:
	velocity_before_move_and_slide = val

func get_velocity_before_move_and_slide() -> Vector2:
	return velocity_before_move_and_slide
