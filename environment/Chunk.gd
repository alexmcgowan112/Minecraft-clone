extends Spatial


var block = load("res://environment/Block.tscn")

var noise
var player

var blocks = []

func _init(worldNoise, thePlayer, position : Vector2):
	noise = worldNoise
	player = thePlayer
	translation.x = position.x
	translation.z = position.y
	
	for i in range(-5,5):
		for j in range(-5,5):
			var height = int(noise.get_noise_2d(position.x+i,position.y+j)*25)
			var newBlock = block.instance()
			add_child(newBlock)
			newBlock.translation = Vector3(i,height,j)
			blocks.append(newBlock)
