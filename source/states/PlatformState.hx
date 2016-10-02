package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

import objects.Coin;
import objects.Obtainable;
import objects.Player;
import objects.Warp;
import utils.LevelLoader;

class PlatformState extends FlxState
{
    public var backdrops(default, null):FlxTypedGroup<FlxSprite>;

    public var mapBackground:FlxTilemap;
    public var mapPlatforms:FlxTilemap;
    public var mapCollide:FlxTilemap;
    public var mapForeground:FlxTilemap;

    public var warps:FlxGroup;
    public var obtainables:FlxGroup;
    public var coins(default, null):FlxTypedGroup<FlxSprite>;
    public var enemies(default, null):FlxTypedGroup<FlxSprite>;

    public var player(default, null):Player;

	override public function create():Void
	{
        Reg.STATE = cast this;

        // Initialize map backdrops, objects, & player
        backdrops = new FlxTypedGroup<FlxSprite>();
        warps = new FlxGroup();
        obtainables = new FlxGroup();
        coins = new FlxTypedGroup<FlxSprite>();
        enemies = new FlxTypedGroup<FlxSprite>();
        player = new Player();

        // Load the level
        LevelLoader.loadLevel(Reg.LEVEL);

        // Add objects to state
        add(warps);
        add(backdrops);
        obtainables.add(coins);
        add(mapBackground);
        add(obtainables);
        add(enemies);
        add(mapPlatforms);
        add(player);
        add(mapCollide);
        add(mapForeground);

        // Set camera scroll type & bounds
        FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
        FlxG.camera.setScrollBoundsRect(0, 0, mapCollide.width, mapCollide.height, true);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
        super.update(elapsed);

        // Player collision detection
        if (player.alive)
        {
            FlxG.overlap(obtainables, player, collectObtainables);
            FlxG.overlap(warps, player, warpPlayer);
            FlxG.collide(mapPlatforms, player);
            FlxG.collide(mapCollide, player);
        }

        // Enemy collision detection
        FlxG.collide(mapCollide, enemies);
	}

    private function collectObtainables(obtainable:Obtainable, player:Player):Void
    {
        obtainable.collect();
    }

    private function warpPlayer(warp:Warp, player:Player):Void
    {
        if (player.lookingUp)
            warp.warpToLevel();
    }
}
