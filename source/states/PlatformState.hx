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
import objects.Screen;
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
    public var screens:FlxGroup;
    public var obtainables:FlxGroup;
    public var coins(default, null):FlxTypedGroup<FlxSprite>;
    public var enemies:FlxGroup;

    public var player(default, null):Player;
    public var activeScreen:Screen;
    public var screenTransitioning:Bool = false;

	override public function create():Void
	{
        Reg.STATE = cast this;

        // Initialize map backdrops, objects, & player
        backdrops = new FlxTypedGroup<FlxSprite>();
        warps = new FlxGroup();
        screens = new FlxGroup();
        obtainables = new FlxGroup();
        coins = new FlxTypedGroup<FlxSprite>();
        enemies = new FlxGroup();
        player = new Player();

        // Load the level
        // TODO make LevelLoader return a 'Map' object
        LevelLoader.loadLevel(Reg.LEVEL);

        FlxG.camera.setScrollBoundsRect(0, 0, mapCollide.width, mapCollide.height, true);
        FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);

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

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
        super.update(elapsed);

        // Player collision detection
        if (player.alive)
        {
            FlxG.collide(mapCollide, player);
            FlxG.overlap(obtainables, player, collectObtainables);
            FlxG.overlap(warps, player, warpPlayer);
            FlxG.collide(mapPlatforms, player);
            FlxG.overlap(screens, player, screenTransition);
        }

        // Enemy collision detection
        FlxG.collide(mapCollide, enemies);
        FlxG.collide(mapPlatforms, enemies);
        FlxG.collide(enemies, enemies);
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

    private function screenTransition(screen:Screen, player:Player):Void
    {
        // If this is already the active screen, skip
        if (screen == activeScreen)
            return;
        
        // If we're transitioning to a new screen, skip
        if (screenTransitioning)
            return;

        screenTransitioning = true;
        screen.transition(this);
    }
}
