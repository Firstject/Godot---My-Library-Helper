# RandomNodePicker
# Written by: First

extends Node

class_name RandomNodePicker

"""
	RandomNodePicker randomly pick a node within scene tree.
	You can specify where the root node is and it will fetch
	the children and pick one. Note that it can detect this node
	as well but there is an option to avoid this.
	
	The drawback is when it randomly pick an object, it may caught
	this object too. So that might not what you want to be.
	To fix this, an option to not pick this object is available
	at the cost of performance where it traverses through
	number of children to exclude this object (the more node,
	the worst time it takes).
	
	To pick a random node, you can call a method `pick_random()`.
	A signal is emitted when an object is picked.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

signal picked(node)

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#The node which children will be fetched.
export (NodePath) var root_node = "./.." setget set_root_node, get_root_node

#When picking an object, it will never iterate through this node.
export (bool) var exclude_this_node = true setget set_exclude_this_node, is_exclude_this_node

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#Pick a random object from a specified `root_node`.
#A null object is returned if the root node is vanished or
#having no children.
func pick_random() -> Node:
	var _fetched_root_node : Node = get_node_or_null(root_node)
	var _fetched_children : Array
	var _picked_node : Node
	
	if _fetched_root_node == null:
		_push_error_root_node_vanished()
		return null
	if _fetched_root_node.get_child_count() == 0:
		return null
	
	_fetched_children = _fetched_root_node.get_children()
	
	if exclude_this_node:
		_fetched_children = _remove_picker_from_children(_fetched_children)
		if _fetched_children.empty():
			return null
	
	_picked_node = _fetched_children[randi() % _fetched_children.size() - 1]
	emit_signal("picked", _picked_node)
	return _picked_node

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#Remove this object in the array regardless if it is found or not.
func _remove_picker_from_children(var children : Array) -> Array:
	var children_with_pickers_removed : Array
	
	while not children.empty():
		if not children.front() == self:
			children_with_pickers_removed.push_back(children.pop_front())
		else:
			children.pop_front()
	
	return children_with_pickers_removed

func _push_error_root_node_vanished() -> void:
	push_error(str(self, "Can't pick random. The root node might has been vanished or disappeared."))

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_root_node(val : NodePath) -> void:
	root_node = val

func get_root_node() -> NodePath:
	return root_node

func set_exclude_this_node(val : bool) -> void:
	exclude_this_node = val

func is_exclude_this_node() -> bool:
	return exclude_this_node
