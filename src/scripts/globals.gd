extends Node

enum TileType {
	FOREST,
	MEADOW,
	MOUNTAIN,
	WATER
}

enum GameState {
	PLACING_TILE,
	SELECTING_CARD
}

@export var game_state: GameState = GameState.SELECTING_CARD

@export var tiles: Dictionary[Vector2, TileType] = {
	Vector2(0, 0): TileType.MEADOW
}
