extends Spatial


var noise = OpenSimplexNoise.new()

var block = load("res://environment/Block.tscn")

var test

const renderDist = 2

onready var player = $Player
onready var loadingScreen = $LoadingScreen

var playerPosition : Vector2 = Vector2()

var world = []

func load_world():
	randomize()
	noise.seed = randi()
	noise.octaves = 2
	for i in range(-renderDist,renderDist+1):
		var row = []
		for j in range(-renderDist, renderDist+1):
			var height = int(noise.get_noise_2d(i,j)*25)
			var newBlock = block.instance()
			add_child(newBlock)
			newBlock.translation = Vector3(i,height,j)
			row.append(newBlock)
		loadingScreen.set_progress((i+renderDist+1)*(2*renderDist+1), pow((renderDist*2+1),2))
		world.append(row)
	loadingScreen.fade(2)
	player.translation.y = int(noise.get_noise_2d(0,0)*25)+1
	
func _process(_delta):
	if world == []:
		load_world()
	if Vector2(player.translation.x, player.translation.z) != playerPosition:
		var moveDir = Vector2(int(player.translation.x), int(player.translation.z)) - playerPosition
		playerPosition = Vector2(int(player.translation.x), int(player.translation.z))
		print(playerPosition)
		
		if moveDir.x > 0:
			var row = []
			for j in range(-renderDist,renderDist+1):
				var height = int(noise.get_noise_2d(renderDist+playerPosition.x,j+playerPosition.y)*25)
				var newBlock = block.instance()
				add_child(newBlock)
				newBlock.translation = Vector3(renderDist+playerPosition.x,height,j+playerPosition.y)
				row.append(newBlock)
			for cube in world[0]:
				cube.queue_free()
			world.remove(0)
			
			world.append(row)
			
		elif moveDir.x < 0:
			var row = []
			for j in range(-renderDist,renderDist+1):
				var height = int(noise.get_noise_2d(-renderDist+playerPosition.x,j+playerPosition.y)*25)
				var newBlock = block.instance()
				add_child(newBlock)
				newBlock.translation = Vector3(-renderDist+playerPosition.x,height,j+playerPosition.y)
				row.append(newBlock)
			for cube in world[renderDist*2]:
				cube.queue_free()
			world.remove(renderDist*2)
			
			world.insert(0,row)
		if moveDir.y > 0:
			for i in range(-renderDist,renderDist+1):
				var row = world[i+renderDist]
				var height = int(noise.get_noise_2d(i+playerPosition.x,renderDist+playerPosition.y)*25)
				var newBlock = block.instance()
				add_child(newBlock)
				newBlock.translation = Vector3(i+playerPosition.x,height,renderDist+playerPosition.y)
				row.append(newBlock)
				row[0].queue_free()
				row.remove(0)
		elif moveDir.y < 0:
			for i in range(-renderDist,renderDist+1):
				var row = world[i+renderDist]
				var height = int(noise.get_noise_2d(i+playerPosition.x,-renderDist+playerPosition.y)*25)
				var newBlock = block.instance()
				add_child(newBlock)
				newBlock.translation = Vector3(i+playerPosition.x,height,-renderDist+playerPosition.y)
				row.insert(0,newBlock)
				row[renderDist*2].queue_free()
				row.remove(renderDist*2)
