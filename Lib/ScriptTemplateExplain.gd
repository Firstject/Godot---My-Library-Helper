# Script_Name_Here
# Written by: Enter_your_name_here

extends Node

#class_name 

"""
	THIS TEMPLATE CONTAINS THE DESCRIPTION IN DETAILS. TO COPY THIS
	TEMPLATE, YOU SHOULD GO TO ScriptTemplate.gd instead.
	
	Enter class descriptions, and explain in every details.
	For each lines, column numbers should not exceed over 70 letters
	to make it easier to read.
	Script template should be used every time you created
	a new script to make your code cleaner.
	If this is a collaborative project you're working with
	foreigners, you should write the documentation in English.
"""

#-------------------------------------------------
#      Classes
# e.g. class Rule extends Reference:
#      	   
#      	   ##### PROPERTIES #####
#      	   
#      	   var _regex: RegEx
#      	   var _replacement: String
#      	   
#      	   ##### NOTIFICATIONS #####
#      	   
#      	   func _init(p_rule: String, p_replacement: String) -> void:
#      	   	   _regex = RegEx.new()
#      	   	   #warning-ignore:return_value_discarded
#      	   	   _regex.compile(p_rule)
#      	   	   _replacement = p_replacement
#      	   
#      	   ##### PUBLIC METHODS #####
#      	   
#      	   func apply(p_word: String):
#      	   	   if not _regex.search(p_word):
#      	   	   	   return null
#      	   	   return _regex.sub(p_word, _replacement)
#-------------------------------------------------

#-------------------------------------------------
#      Signals
# e.g. signal reloaded
# e.g. signal spawned
# e.g. signal dead(optional_variable)
#-------------------------------------------------

#-------------------------------------------------
#      Constants
# e.g. const MAX_POWER_ALLOWED = 256
# e.g. const FIXED_RESOURCE_NAME = "Custom"
# e.g. const PENETRABLE = false
# e.g. enum AttackPattern {
#      	   IDLE,
#      	   MOVE,
#      	   MOVE_ATTACK
#      }
#-------------------------------------------------

#-------------------------------------------------
#      Properties
# e.g. export (float) var speed = 120.0
# e.g. export (NodePath) var path_to_obj
# e.g. export (String) var in_game_name
#-------------------------------------------------

#-------------------------------------------------
#      Notifications
# e.g. _get_configuration_warning() -> String:
#      	   if obj == null:
#      	   	   return "Obj is null!"
#      	   else:
#      	   	   return ""
# e.g. _init():
#      	   obj = Object.new()
#      	   my_var = 20
#      	   my_name = "Cascading"
# e.g. _ready() -> void:
#      	   pass
# e.g. _process(delta) -> void:
#      	   pass
#-------------------------------------------------

#-------------------------------------------------
#      Virtual Methods
# e.g. func _item_inserted(p_index: int, p_control: Control):
#      	   pass
# e.g. func _item_removed(p_index: int, p_control: Control):
#      	   pass
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
# e.g. func add_child(p_value: Node, p_legible_unique_name: bool = false):
#      	   .add_child(p_value, p_legible_unique_name)
#      	   if p_value and p_value is Control:
#      	   	   (p_value as Control).set_as_toplevel(true)
#
# e.g. func remove_child(p_value: Node):
#      	   .remove_child(p_value)
#      	   if p_value and p_value is Control:
#      	   	   (p_value as Control).set_as_toplevel(false)
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
# e.g. func add_slot(id : int) -> void:
#      	   for i in inv.get_my_slots():
#      	   	   if i == null:
#      	   	   	   i = ItemSlot.new(id)
#      	   	   	   return
# e.g. static func static_get_script_class_list() -> PoolStringArray:
#      	   return PoolStringArray(_get_script_map().keys())
#-------------------------------------------------

#-------------------------------------------------
#      Connections
# e.g. func _on_edit_text_entered(p_text: String, p_edit: LineEdit, p_label: Label):
#      	   p_label.text = p_text
#      	   p_label.show()
#      	   p_edit.hide()
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
# e.g. func _within_numbers(val : int, min_val : int, max_val : int) -> bool:
#      	   return val >= min_val && val <= max_val
#-------------------------------------------------

#-------------------------------------------------
#      Setters & Getters
# e.g. _set_name(val) -> void:
#      	   name = val
# e.g. _get_name() -> String:
#      	   return name
#-------------------------------------------------
