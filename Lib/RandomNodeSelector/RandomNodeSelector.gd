# RandomNodeSelector
# Written by: First

extends Node

class_name RandomNodeSelector

"""
	RandomNodeSelector simply selects node within scene tree.
	You can specify where the root node is and it will fetch
	the children and select them. Note that it can detect this node
	as well but there is an option to avoid that.
	
	**Algorithm complexity**
	
	The drawback is when it randomly select an object, it may caught
	the selector (this object) too.
	To fix this, an option to not select this object is available
	at the cost of performance where it traverses through
	number of children to exclude this object (the more node,
	the worst time it takes).
	
	To select a random node, you can call a method `select_random()`.
	A signal is emitted when an object is picked.
	Multiple nodes can also be selected using `select_multi_random()`
	and `select_inverse_multi_random()`
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#This signal is emitted when function `select_random()` is called.
#Returns a parameter of selected node object.
signal selected(node)

#This signal is emitted when function `select_multi_random()` is called.
#Returns a parameter of selected node object as an array.
signal multi_selected(node_array)

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#The node where children will be fetched.
export (NodePath) var root_node = "./.." setget set_root_node, get_root_node

#When selecting a node, it will never iterate through this node.
export (bool) var exclude_this_node = true setget set_exclude_this_node, is_exclude_this_node

#Selected nodes after the selection calls.
var selected_nodes : Array setget ,get_selected_nodes

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

#Pick a random child node start from `root_node`.
#A null object is returned if the root node is vanished or
#having no children.
func select_random() -> Node:
	var _fetched_root_node : Node = get_node_or_null(root_node)
	var _fetched_children : Array
	var _selected_node : Node
	
	#Return null if root node is vanished or having no children.
	if _fetched_root_node == null:
		_push_root_node_vanished_error()
		return null
	if _fetched_root_node.get_child_count() == 0:
		return null
	
	#Get children from the root node.
	_fetched_children = _fetched_root_node.get_children()
	
	#If 'exclude_this_node' is enabled, exclude this node from
	#fetched children.
	if exclude_this_node:
		_fetched_children = _remove_selector(_fetched_children)
	
	#At the end after exclusion nodes. If the fetched children become
	#emptied, return null immediately.
	if _fetched_children.empty():
			return null
	
	#Select a random node, emit signal and pass a selected node,
	#and return a selected node.
	_selected_node = _fetched_children[randi() % _fetched_children.size() - 1]
	emit_signal("selected", _selected_node)
	selected_nodes = [_selected_node]
	return _selected_node

#Pick multiple random child nodes start from `root_node` by an amount.
#A null object is returned if the root node is vanished or
#having no children.
func select_multi_random(var node_count : int) -> Array:
	var _fetched_root_node : Node = get_node_or_null(root_node)
	var _fetched_children : Array
	var _selected_node : Array
	
	#Return empty array if root node is vanished or having no children
	#or number to select is <= zero.
	if _fetched_root_node == null:
		_push_root_node_vanished_error()
		return []
	if _fetched_root_node.get_child_count() == 0:
		return []
	if node_count <= 0:
		return []
	
	#Get children from the root node.
	_fetched_children = _fetched_root_node.get_children()
	
	#If 'exclude_this_node' is enabled, exclude this node from
	#fetched children.
	if exclude_this_node:
		_fetched_children = _remove_selector(_fetched_children)
	
	#At the end after exclusion nodes. If the fetched children become
	#emptied, return an empty array immediately.
	if _fetched_children.empty():
			return []
	
	#Limit number of nodes to be selected
	if node_count > _fetched_children.size():
		node_count = _fetched_children.size()
	
	#Iterate through fetched children.
	#Pick random one children and add to _selected_node and then
	#remove a children.
	for i in node_count:
		var rand_idx : int = randi() % _fetched_children.size()
		_selected_node.append(_fetched_children[rand_idx])
		_fetched_children.remove(rand_idx)
	
	emit_signal("multi_selected", _selected_node)
	selected_nodes = _selected_node
	return _selected_node

#Pick multiple random child nodes start from `root_node` by an amount.
#The selection become inversed at the end of the process.
#A parameter of `node_remain_count` should be passed as a number
#of unselected node.
#A null object is returned if the root node is vanished or
#having no children.
func select_inverse_multi_random(var node_remain_count : int) -> Array:
	var _fetched_root_node : Node = get_node_or_null(root_node)
	var _fetched_children : Array
	var _selected_node : Array
	
	#Return empty array if root node is vanished or having no children
	#or number to select is <= zero.
	if _fetched_root_node == null:
		_push_root_node_vanished_error()
		return []
	if _fetched_root_node.get_child_count() == 0:
		return []
	if node_remain_count <= 0:
		return []
	
	#Get children from the root node.
	_fetched_children = _fetched_root_node.get_children()
	
	#If 'exclude_this_node' is enabled, exclude this node from
	#fetched children.
	if exclude_this_node:
		_fetched_children = _remove_selector(_fetched_children)
	
	#At the end after exclusion nodes. If the fetched children become
	#emptied, return an empty array immediately.
	if _fetched_children.empty():
		return []
	
	#Limit number of nodes to be selected
	if node_remain_count > _fetched_children.size():
		node_remain_count = _fetched_children.size()
	
	#Iterate through fetched children.
	#Pick random one children and add to _selected_node and then
	#remove a children.
	for i in _fetched_children.size() - node_remain_count:
		var rand_idx : int = randi() % _fetched_children.size()
		_selected_node.append(_fetched_children[rand_idx])
		_fetched_children.remove(rand_idx)
	
	emit_signal("multi_selected", _selected_node)
	selected_nodes = _selected_node
	return _selected_node

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#Remove this object in the array regardless if it is found or not.
func _remove_selector(var children : Array) -> Array:
	children.erase(self)
	
	return children

func _push_root_node_vanished_error() -> void:
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

func get_selected_nodes() -> Array:
	return selected_nodes
