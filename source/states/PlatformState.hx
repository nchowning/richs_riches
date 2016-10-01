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
import utils.LevelLoader;

class PlatformState extends FlxState
{
    public var backdrops(default, null):FlxTypedGroup<FlxSprite>;

    public var mapBackground:FlxTilemap;
    public var mapCollide:FlxTilemap;
    public var mapForeground:FlxTilemap;

    public var obtainables:FlxGroup;
    public var coins(default, null):FlxTypedGroup<FlxSprite>;
    public var enemies(default, null):FlxTypedGroup<FlxSprite>;

    public var player(default, null):Player;

	override public function create():Void
	{
        Reg.STATE = cast this;

        // Set the background color to the lightest of our pallette
        FlxG.cameras.bgColor = new FlxColor(0xffd3e29a);

        // Initialize map backdrops, objects, & player
        backdrops = new FlxTypedGroup<FlxSprite>();
        obtainables = new FlxGroup();
        coins = new FlxTypedGroup<FlxSprite>();
        enemies = new FlxTypedGroup<FlxSprite>();
        player = new Player();

        // Load the level
        LevelLoader.loadLevel("test_map");

        // Add objects to state
        add(backdrops);
        obtainables.add(coins);
        add(mapBackground);
        add(obtainables);
        add(enemies);
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
            FlxG.collide(mapCollide, player);
        }

        // Enemy collision detection
        FlxG.collide(mapCollide, enemies);
	}

    function collectObtainables(obtainable:Obtainable, player:Player):Void
    {
        obtainable.collect();
    }
}
