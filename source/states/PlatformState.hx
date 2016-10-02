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
    public var mapPlatforms:FlxTilemap;
    public var mapCollide:FlxTilemap;
    public var mapForeground:FlxTilemap;

    public var obtainables:FlxGroup;
    public var coins(default, null):FlxTypedGroup<FlxSprite>;
    public var enemies(default, null):FlxTypedGroup<FlxSprite>;

    public var player(default, null):Player;

	override public function create():Void
	{
        Reg.STATE = cast this;

        // Initialize map backdrops, objects, & player
        backdrops = new FlxTypedGroup<FlxSprite>();
        obtainables = new FlxGroup();
        coins = new FlxTypedGroup<FlxSprite>();
        enemies = new FlxTypedGroup<FlxSprite>();
        player = new Player();

        // Load the level
        LevelLoader.loadLevel("level_select");

        // Add objects to state
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
            FlxG.collide(mapPlatforms, player);
            FlxG.collide(mapCollide, player);
        }

        // Enemy collision detection
        FlxG.collide(mapCollide, enemies);
	}

    function platformCollision(tile:FlxTilemap, player:Player):Void
    {
        FlxObject.separate(tile, player);
    }

    function collectObtainables(obtainable:Obtainable, player:Player):Void
    {
        obtainable.collect();
    }
}
