package game.char;

import flixel.util.FlxPath;

class Player extends Actor {
	public var walkPath:Array<FlxPoint>;
	public var ai:State;
	public var isStart:Bool;
	public var playerPath:FlxSprite;

	public function new(x:Float, y:Float, actorData:ActorData,
			path:Array<FlxPoint>) {
		super(x, y, actorData);
		makeGraphic(16, 16, KColor.WHITE, true);
		walkPath = path;
		this.path = new FlxPath(walkPath);
		playerPath = new FlxSprite(0, 0);
		playerPath.makeGraphic(FlxG.width, FlxG.height, KColor.TRANSPARENT);
		for (index in 0...this.path.nodes.length) {
			if (index > 0) {
				var lastPoint = this.path.nodes[index - 1];
				var currPoint = this.path.nodes[index];
				playerPath.drawLine(lastPoint.x, lastPoint.y, currPoint.x,
					currPoint.y, {
						thickness: 4,
						color: KColor.RICH_BLACK_FORGRA,
					});
			}
		}
		FlxG.state.add(playerPath);
		ai = new State(idle);
		this.startPathing();
	}

	public function idle(elapsed:Float) {
		if (isStart) {
			this.path.start(null, this.spd, FlxPath.LOOP_FORWARD);
			ai.currentState = followingPath;
		} else {
			// Do nothing
		}
	}

	public function followingPath(elapsed:Float) {
		if (!isStart) {
			// TODO: determine if we should reset or stay in the same place.
			ai.currentState = idle;
		} else {}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		ai.update(elapsed);
	}

	public function startPathing() {
		isStart = true;
	}

	public function endPathing() {
		isStart = false;
	}
}