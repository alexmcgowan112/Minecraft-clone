extends Spatial


var noise = OpenSimplexNoise.new()

var chunkScene = preload("res://environment/Chunk.gd")

var test

const renderDist = 2

onready var player = $Player
onready var loadingScreen = $LoadingScreen

var playerPosition : Vector2 = Vector2()

var chunks = []

func _ready():
	load_world()

func load_world():
	randomize()
	noise.seed = randi()
	for i in range(-renderDist, renderDist+1):
		for j in range(-renderDist, renderDist+1):
			var newChunk = chunkScene.new(noise, player, Vector2(i*10, j*10))
			add_child(newChunk)
			chunks.append(newChunk)
		loadingScreen.set_progress((i+renderDist+1)*(2*renderDist+1), pow((renderDist*2+1),2))
		print((i+renderDist+1)*(2*renderDist+1),"/", pow((renderDist*2+1),2)," chunks loaded")
	loadingScreen.fade(1)
	player.translation.y = int(noise.get_noise_2d(0,0)*25)+1
	
func _process(_delta):
	for chunk in chunks:
		var xDist = player.translation.x - chunk.translation.x
		if xDist > 5 + renderDist*10:
			var newChunk = chunkScene.new(noise, player, Vector2(chunk.translation.x + renderDist * 20 + 10, chunk.translation.z))
			add_child(newChunk)
			chunks.append(newChunk)
			chunks.erase(chunk)
			chunk.queue_free()
		elif xDist < -5 - renderDist*10:
			var newChunk = chunkScene.new(noise, player, Vector2(chunk.translation.x - renderDist * 20 - 10, chunk.translation.z))
			add_child(newChunk)
			chunks.append(newChunk)
			chunks.erase(chunk)
			chunk.queue_free()
		var zDist = player.translation.z - chunk.translation.z
		if zDist > 5 + renderDist*10:
			var newChunk = chunkScene.new(noise, player, Vector2(chunk.translation.x, chunk.translation.z + renderDist * 20 + 10))
			add_child(newChunk)
			chunks.append(newChunk)
			chunks.erase(chunk)
			chunk.queue_free()
		elif zDist < -5 - renderDist*10:
			var newChunk = chunkScene.new(noise, player, Vector2(chunk.translation.x, chunk.translation.z - renderDist * 20 - 10))
			add_child(newChunk)
			chunks.append(newChunk)
			chunks.erase(chunk)
			chunk.queue_free()
				
			
