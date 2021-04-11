package game.char;

import flixel.util.FlxPath;

class Player extends Actor {
	public var walkPath:Array<FlxPoint>;
	public var ai:State;
	public var isStart:Bool;

	public function new(x:Float, y:Float, actorData:ActorData,
			path:Array<FlxPoint>) {
		super(x, y, actorData);
		makeGraphic(16, 16, KColor.WHITE, true);
		walkPath = path;
		this.path = new FlxPath(walkPath);
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