package game.states;

class LevelOneState extends TileState {
	override public function create() {
		super.create();
		createLevel(AssetPaths.LevelOne__tmx);
	}
}