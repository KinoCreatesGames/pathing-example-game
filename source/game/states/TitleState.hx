package game.states;

import game.ui.TextButton;
import flixel.util.FlxAxes;

/**
 * Add Press Start Before entering main scene for title
 * as part of the update functionality
 */
class TitleState extends FlxState {
	public var pressStartText:FlxText;
	public var playButton:TextButton;
	public var continueButton:TextButton;
	public var optionsButton:TextButton;
	public var creditsButton:TextButton;
	public var completeFadeStart:Bool;
	#if desktop
	public var exitButton:TextButton;
	#end

	override public function create() {
		FlxG.mouse.visible = true;
		// bgColor = KColor.RICH_BLACK_FORGRA;
		bgColor = 0xFFb2cede;
		// Create Title Text
		var text = new FlxText(0, 0, -1, Globals.GAME_TITLE, 32);
		add(text);
		text.alignment = CENTER;
		text.screenCenter();
		completeFadeStart = false;
		createPressStart();
		createButtons();
		createControls();
		createVersion();
		super.create();
	}

	public function createPressStart() {
		pressStartText = new FlxText(0, 0, -1, 'Press Any Button To Start',
			Globals.FONT_N);
		pressStartText.screenCenter();
		pressStartText.y += 90;
		// add later
		add(pressStartText);
		pressStartText.flicker(0, .4);
	}

	public function createButtons() {
		// Create Buttons
		var y = 40;
		playButton = new TextButton(0, 0, Globals.TEXT_START, Globals.FONT_N,
			clickStart);
		playButton.hoverColor = KColor.BURGUNDY;
		playButton.clickColor = KColor.BURGUNDY;
		playButton.screenCenter();
		playButton.y += y;
		y += 40;

		// Add Buttons

		playButton.canClick = false;
		playButton.alpha = 0;

		add(playButton);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updatePressStart(elapsed);
	}

	public function updatePressStart(elapsed:Float) {
		var keyPressed = FlxG.keys.firstPressed();
		if (keyPressed != -1) {
			pressStartText.stopFlickering();
			pressStartText.visible = false;
		} else if (pressStartText.visible) {}

		var fadeTime = 0.25;
		if (!pressStartText.visible && !pressStartText.isFlickering()
			&& completeFadeStart == false) {
			playButton.fadeIn(fadeTime);
			completeFadeStart = true;
		}

		if (completeFadeStart) {
			playButton.canClick = true;
		}
	}

	public function clickStart() {
		FlxG.switchState(new LevelOneState());
	}

	public function createControls() {
		var textWidth = 200;
		var textSize = 12;
		var controlsText = new FlxText(20, FlxG.height - 100, textWidth,
			'How To Move:
UP/DOWN to adjust speed.			
', textSize);
		add(controlsText);
	}

	public function createCredits() {
		var textWidth = 200;
		var textSize = 12;
		var creditsText = new FlxText(FlxG.width - textWidth,
			FlxG.height - 100, textWidth, 'Created by KinoCreates', textSize);
		// add(creditsText);
	}

	public function createVersion() {
		var textWidth = 200;
		var textSize = 12;
		var versionText = new FlxText(FlxG.width - textWidth,
			FlxG.height - 100, textWidth, Globals.TEXT_VERSION, textSize);
		versionText.screenCenter(FlxAxes.X);
		add(versionText);
	}
}