package game.ui;

class HUD extends FlxTypedGroup<FlxSprite> {
	public var position:FlxPoint;
	public var player:Player;
	public var moreSpdBtn:FlxButton;
	public var lessSpdBtn:FlxButton;
	public var initialSpd:Float;
	public var gameTimeText:FlxText;

	public function new(x:Float, y:Float, player:Player) {
		super();
		this.position = new FlxPoint(x, y);
		this.player = player;
		initialSpd = player.spd;
		create();
	}

	public function create() {
		createSpdButtons();
		createGameTime();
	}

	public function createGameTime() {
		var y = 32;
		gameTimeText = new FlxText(0, y, -1, 'Time ', Globals.FONT_L);
		gameTimeText.screenCenterHorz();
		add(gameTimeText);
	}

	public function createSpdButtons() {
		var x = FlxG.width - 200;
		var y = 32;
		var spacing = 16;
		moreSpdBtn = new FlxButton(x, y, 'Speed Up', clickSpeedUp);
		lessSpdBtn = new FlxButton(moreSpdBtn.x + moreSpdBtn.width + spacing,
			y, 'Slow Down', clickSpeedDwn);

		add(moreSpdBtn);
		add(lessSpdBtn);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	public function clickSpeedUp() {
		player.spd += cast initialSpd * 0.5;
		player.path.speed = player.spd;
	}

	public function clickSpeedDwn() {
		player.spd -= cast initialSpd * 0.5;
		player.spd = player.spd.clamp(0, 2000000);
		player.path.speed = player.spd;
	}

	public function updateGameTime(value:Float) {
		var valueText = '${Math.ceil(value)}';
		gameTimeText.text = 'Time: ${valueText.lpad("0", 2)}';
	}
}