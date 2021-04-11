package game.char;

import flixel.math.FlxVelocity;

/**
 * Tadpole enemy spawns at the corners of the screen.
 * This enemy will do damage to you when you get hit.
 */
class Tadpole extends Enemy {
	public var idleTime:Float;

	public static inline var IDLE_TIME:Float = 2.5;

	public var countdown:Float = 1;

	public function new(x:Float, y:Float, monsterData:MonsterData,
			player:Player) {
		super(x, y, null, monsterData, player);
		makeGraphic(16, 16, KColor.RED, true);
	}

	public function attack(elapsed:Float) {
		FlxVelocity.moveTowardsObject(this, player, this.spd, 0);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (!this.isOnScreen() && countdown <= 0) {
			this.kill();
		}
		countdown -= elapsed;
	}
}