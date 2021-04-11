package game.char;

import flixel.math.FlxVelocity;

class Enemy extends game.char.Actor {
	public var walkPath:Array<FlxPoint>;
	public var player:Player;
	public var points:Int;

	public function new(x:Float, y:Float, path:Array<FlxPoint>,
			monsterData:MonsterData, player:Player) {
		super(x, y, monsterData);
		this.player = player;
		walkPath = path;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateMovement(elapsed);
	}

	public function updateMovement(elapsed:Float) {}
}