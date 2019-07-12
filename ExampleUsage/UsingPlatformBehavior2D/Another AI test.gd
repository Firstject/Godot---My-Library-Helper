extends KinematicBody2D

onready var pf_bhv := $PlatformBehavior2D as User_PlatformBehavior2D #In short, pf_bhv is PlatformBehavior2D

var state : bool = true #If true, it moves left. Otherwise, right

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pf_bhv.simulate_walk_left = state
	pf_bhv.simulate_walk_right = !state

#When hit by wall, change moving direction.
func _on_PlatformBehavior2D_by_wall() -> void:
	toggle_move_direction()

func toggle_move_direction() -> void:
	state = !state
