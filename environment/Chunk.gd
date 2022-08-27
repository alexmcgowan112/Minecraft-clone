extends Spatial


var block = load("res://environment/Block.tscn")

var position : Vector2 = Vector2()

var noise
var player

var blocks = []

func _init(noise, player):
	self.noise = noise
	self.player = player
	
	for i in range(-5,6):
		var row = []
		for j in range(-5,6):
			var height = int(noise.get_noise_2d(i,j)*25)
			var newBlock = block.instance()
			add_child(newBlock)
			newBlock.translation = Vector3(i,height,j)
			row.append(newBlock)
		blocks.append(row)
	
