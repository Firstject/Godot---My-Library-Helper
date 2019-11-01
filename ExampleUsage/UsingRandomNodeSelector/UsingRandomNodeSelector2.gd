extends Node

var selected_nodes : Array
var picked_node_name : String

func _ready():
	#Randomize seed (for a different result each time this scene starts)
	randomize()

func pick_delete_random_nodes():
	#Pick random multiple nodes.
	selected_nodes.clear()
	selected_nodes = $Sprites/RandomNodeSelector.select_multi_random($Info/DelCountSpinBox.value)
	if selected_nodes.empty():
		#Set text where no node has been deleted.
		$Info/DeletedNodeLabel.set_text("Nothing selected")
	else:
		#Set text how many nodes deleted.
		$Info/DeletedNodeLabel.set_text(str("Picked and deleted ", selected_nodes.size(), " sprites."))
		
		#Queue free picked nodes.
		for i in selected_nodes:
			i.queue_free()

func pick_delete_random_nodes_inverse():
	#Pick random multiple nodes.
	selected_nodes.clear()
	selected_nodes = $Sprites/RandomNodeSelector.select_inverse_multi_random($Info/DelCountSpinBox.value)
	if selected_nodes.empty():
		#Set text where no node has been deleted.
		$Info/DeletedNodeLabel.set_text("Nothing selected")
	else:
		#Set text how many nodes deleted.
		$Info/DeletedNodeLabel.set_text(str("Picked and deleted ", selected_nodes.size(), " sprites."))
		
		#Queue free picked nodes.
		for i in selected_nodes:
			i.queue_free()

func _on_DelNodeButton_pressed():
	pick_delete_random_nodes()

func _on_DelNodeInverseButton_pressed():
	pick_delete_random_nodes_inverse()
