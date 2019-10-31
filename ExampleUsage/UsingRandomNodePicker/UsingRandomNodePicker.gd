extends Node

var picked_node : Node
var picked_node_name : String

func _ready():
	#Randomize seed (for a different result each time this scene starts)
	randomize()

func pick_delete_random_node():
	#Pick random a node.
	picked_node = $Sprites/RandomNodePicker.pick_random()
	picked_node_name = picked_node.name
	
	#Set text which node has been deleted.
	$Info/DeletedNodeLabel.set_text(picked_node_name + " is picked and then get deleted")
	
	#Queue free a picked node.
	picked_node.queue_free()

func _on_RandomPickDeleteTimer_timeout():
	pick_delete_random_node()
