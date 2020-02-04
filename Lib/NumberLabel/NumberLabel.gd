# NumberLabel
# Written by: First

extends Label

class_name User_NumberLabel

"""
	NumberLabel is an extended Label node that tween the number value
	and display it as text. When the value of the number changes,
	the text smoothly transits its number over time.
	
	NOTE that the node will update its text when the property `number`
	is changed. If you want to set something like '25/30' it is highly
	recommended to have separated labels.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Constants
#-------------------------------------------------

enum TextDisplayMode {
	INTEGER,
	FLOAT
}

enum TransitionType {
	TRANS_LINEAR, #The animation is interpolated linearly.
	TRANS_SINE, #The animation is interpolated using a sine function.
	TRANS_QUINT, #The animation is interpolated with a quintic (to the power of 5) function.
	TRANS_QUART, #The animation is interpolated with a quartic (to the power of 4) function.
	TRANS_QUAD, #The animation is interpolated with a quadratic (to the power of 2) function.
	TRANS_EXPO, #The animation is interpolated with an exponential (to the power of x)
	TRANS_ELASTIC, #The animation is interpolated with elasticity, wiggling around the edges.
	TRANS_CUBIC, #The animation is interpolated with a cubic (to the power of 3) function.
	TRANS_CIRC, #The animation is interpolated with a function using square roots.
	TRANS_BOUNCE, #The animation is interpolated by bouncing at the end.
	TRANS_BACK #The animation is interpolated backing out at ends.
}

enum EaseType {
	EASE_IN, #The interpolation starts slowly and speeds up towards the end.
	EASE_OUT, #The interpolation starts quickly and slows down towards the end.
	EASE_IN_OUT, #A combination of EASE_IN and EASE_OUT. The interpolation is slowest at both ends.
	EASE_OUT_IN #A combination of EASE_IN and EASE_OUT. The interpolation is fastest at both ends.
}

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (float) var number setget set_number, get_number

export (TextDisplayMode) var text_display_mode

export (float) var update_duration = 0.5

export (TransitionType) var update_transition_type = TransitionType.TRANS_LINEAR

export (EaseType) var update_ease_type = EaseType.EASE_OUT

export (float) var update_delay = 0

export (bool) var autostart_update = true

export (float) var autostart_from = 0


var current_number_value : float


onready var tween := $Tween

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready() -> void:
	if autostart_update:
		_start_text_tween(autostart_from)
	else:
		#Make current number value default; init current number value
		current_number_value = number

func _process(_delta: float) -> void:
	if tween == null:
		return
	if not tween.is_active():
		return
	
	_process_update_text()

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#Update to make the text transits to current number.
func update_text() -> void:
	_start_text_tween()

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _start_text_tween(custom_current_number_value : float = current_number_value) -> void:
	if tween == null:
		return
	
	tween.interpolate_property(self, "current_number_value", custom_current_number_value, number, update_duration, update_transition_type, update_ease_type, update_delay)
	tween.start()

func _process_update_text():
	match text_display_mode:
		TextDisplayMode.FLOAT:
			set_text(str(current_number_value))
		TextDisplayMode.INTEGER:
			set_text(str(int(current_number_value)))

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_number(val : float) -> void:
	number = val
	_start_text_tween()

func get_number() -> float:
	return number
