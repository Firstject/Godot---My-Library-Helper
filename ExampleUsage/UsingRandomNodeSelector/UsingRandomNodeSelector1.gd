extends Node

var selected_node : Node
var picked_node_name : String

func _ready():
	#Randomize seed (for a different result each time this scene starts)
	randomize()

func pick_delete_random_node():
	#Pick random a node.
	selected_node = $Sprites/RandomNodeSelector.select_random()
	if selected_node == null:
		#Set text where no node has been deleted.
		$Info/DeletedNodeLabel.set_text("Nothing selected")
	else:
		picked_node_name = selected_node.name
		
		#Set text which node has been deleted.
		$Info/DeletedNodeLabel.set_text(picked_node_name + " is picked and then get deleted")
		
		#Queue free a picked node.
		selected_node.queue_free()

func _on_DelNodeButton_pressed():
	pick_delete_random_node()
