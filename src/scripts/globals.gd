extends Node

enum TileType {
	FOREST,
	MEADOW,
	MOUNTAIN,
	WATER
}

@export var tiles: Dictionary[Vector2, TileType] = {
	Vector2(0, 0): TileType.MEADOW
}
