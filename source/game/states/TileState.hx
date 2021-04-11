package game.states;

import game.ui.HUD;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;

class TileState extends BaseTileState {
	public var player:Player;
	public var playerHUD:HUD;
	public var gameTime:Float;

	public var top:FlxPoint;
	public var bottom:FlxPoint;
	public var left:FlxPoint;
	public var right:FlxPoint;

	public var spawnTimer:Float;

	/**
	 * Update this logic to increase or slow down spawning time.
	 */
	public static inline var SPAWN_CD:Float = 4;

	override public function createLevelInformation() {
		// TODO: For Debug Disable AutoPause
		FlxG.autoPause = false;
		super.createLevelInformation();
		// The layer for any tiles to show off the world;
		var tileLayer:TiledTileLayer = cast(map.getLayer('Floor'));
		gameTime = getGameTime();
		createPlayer();
		createLevelCorners();
	}

	override public function createUI() {
		playerHUD = new HUD(0, 0, player);
	}

	public function createLevelCorners() {
		var midX = FlxG.width / 2;
		var midY = FlxG.height / 2;
		var tSize = map.tileHeight;
		top = new FlxPoint(midX, 0);
		bottom = new FlxPoint(midX, FlxG.height);
		left = new FlxPoint(0, midY);
		right = new FlxPoint(FlxG.width, midY);
	}

	public function createPlayer() {
		var objLayer:TiledObjectLayer = cast(map.getLayer('Player'));
		objLayer.objects.iter((obj) -> {
			var path = [];
			for (key => value in obj.properties.keys) {
				// Get all pathing keys
				if (key.contains('path')) {
					// Check if keys are coming out sorted
					// trace(key);
					var xy = obj.properties.get(key)
						.split(",")
						.map((val) -> Std.parseInt(val));
					path.push(new FlxPoint(xy[0] * map.tileWidth,
						xy[1] * map.tileHeight));
				}
			}
			player = new Player(obj.x, obj.y, DepotData.Actors_Lukia, path);
		});
	}

	/**
	 * Overload to determine level time.
	 * Defaults to 60 seconds
	 */
	public function getGameTime() {
		return 30.0;
	}

	override function addGroups() {
		super.addGroups();
		add(player);
		add(playerHUD);
	}

	override public function processCollision() {
		super.processCollision();
		FlxG.overlap(player, enemyGrp, playerTouchEnemy);
	}

	public function playerTouchEnemy(player:Player, enemy:Enemy) {
		FlxG.camera.shake(0.01, 0.1);
		enemy.kill();
		player.health -= 1;
		if (player.health <= 0) {
			player.kill();
		}
	}

	/**
	 * Run through the level time
	 * @param elapsed 
	 */
	override public function processLevel(elapsed:Float) {
		super.processLevel(elapsed);
		updateGameTime(elapsed);
		processGameState();
		updateSpawnEnemies(elapsed);
		processControls(elapsed);
	}

	public function processControls(elapsed:Float) {
		if (FlxG.keys.anyJustPressed([UP])) {
			player.spd += cast playerHUD.initialSpd * 0.5;
			player.path.speed = player.spd;
		}

		if (FlxG.keys.anyJustPressed([DOWN])) {
			player.spd -= cast playerHUD.initialSpd * 0.5;
			player.spd = player.spd.clamp(0, 2000000);
			player.path.speed = player.spd;
		}
	}

	public function updateSpawnEnemies(elapsed:Float) {
		if (spawnTimer <= 0) {
			var sign = FlxG.random.sign();
			trace('Spawn Enemy');
			var spawnPointX = (Math.random() * (FlxG.width / 2)) * sign;
			var spawnPointY = (Math.random() * (FlxG.height / 2)) * sign;
			var topBot = [top, bottom];
			var leftRight = [left, right];
			topBot.iter((spawnPoint) -> {
				var x = spawnPointX + spawnPoint.x;
				var y = spawnPoint.y;
				var enemy = new Tadpole(x, y, DepotData.Enemy_Tadpole, player);
				enemyGrp.add(enemy);
				enemy.attack(0);
			});
			leftRight.iter((otherPoint) -> {
				var x = otherPoint.x;
				var y = otherPoint.y + spawnPointY;
				var enemy = new Tadpole(x, y, DepotData.Enemy_Tadpole, player);
				enemyGrp.add(enemy);
				enemy.attack(0);
			});
			spawnTimer = SPAWN_CD;
		} else {
			spawnTimer -= elapsed;
		}
	}

	public function updateGameTime(elapsed:Float) {
		gameTime -= elapsed;
		gameTime = gameTime.clampf(0, 1000);
		playerHUD.updateGameTime(gameTime);
	}

	public function processGameState() {
		if (player.alive && gameTime <= 0) {
			completeLevel = true;
		}

		if (!player.alive) {
			gameOver = true;
		}

		if (completeLevel) {
			openSubState(new WinSubState());
		}

		if (gameOver) {
			openSubState(new GameOverSubState());
		}
	}
}