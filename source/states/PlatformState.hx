package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

import enemies.Enemy;
import objects.Coin;
import objects.Obtainable;
import objects.Player;
import objects.Screen;
import objects.Warp;
import utils.LevelLoader;

class PlatformState extends FlxState
{
    private var hud:HUD;

    public var backdrops(default, null):FlxTypedGroup<FlxSprite>;

    public var mapBackground:FlxTilemap;
    public var mapPlatforms:FlxTilemap;
    public var mapCollide:FlxTilemap;
    public var mapKill:FlxTilemap;
    public var mapForeground:FlxTilemap;

    public var warps:FlxGroup;
    public var screens:FlxGroup;
    public var obtainables:FlxGroup;
    public var coins(default, null):FlxTypedGroup<FlxSprite>;
    public var enemies:FlxGroup;
    public var explosionFragments:FlxGroup;

    public var player(default, null):Player;
    public var activeScreen:Screen;
    public var screenTransitioning:Bool = false;

	override public function create():Void
	{
        Reg.STATE = cast this;
        Reg.GAMEPAD = FlxG.gamepads.lastActive;

        hud = new HUD();

        // Initialize map backdrops, objects, & player
        backdrops = new FlxTypedGroup<FlxSprite>();
        warps = new FlxGroup();
        screens = new FlxGroup();
        obtainables = new FlxGroup();
        coins = new FlxTypedGroup<FlxSprite>();
        enemies = new FlxGroup();
        explosionFragments = new FlxGroup();
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
        add(explosionFragments);
        add(mapPlatforms);
        add(mapKill);
        add(player);
        add(mapCollide);
        add(mapForeground);

        add(hud);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
        super.update(elapsed);

        // Player collision detection
        if (player.alive)
        {
            FlxG.collide(mapCollide, player);

            FlxG.overlap(obtainables, player, collideWithPlayer);
            FlxG.overlap(warps, player, collideWithPlayer);
            
            FlxG.collide(mapPlatforms, player);
            
            FlxG.overlap(screens, player, collideWithPlayer);
            
            FlxG.overlap(enemies, player, collideWithPlayer);
            FlxG.overlap(explosionFragments, player, collideWithPlayer);
            FlxG.collide(mapKill, player, collideWithPlayer);
        }

        // Enemy collision detection
        FlxG.collide(mapCollide, enemies);
        FlxG.collide(mapPlatforms, enemies);
        FlxG.collide(enemies, enemies);
	}

    private function collideWithPlayer(entity:FlxObject, player:Player):Void
    {
        // Map warp collision
        if (Std.is(entity, Warp))
        {
            if (player.lookingUp)
                (cast entity).warpToLevel();
        }

        // Screen scroll collision
        else if (Std.is(entity, Screen))
        {
            var screen = cast entity;

            // If this is already the active screen, skip
            if (screen == activeScreen)
                return;
            
            // If we're transitioning to a new screen, skip
            if (screenTransitioning)
                return;

            screenTransitioning = true;
            screen.transition(this);
        }

        // Obtainable collision
        else if (Std.is(entity, Obtainable))
            (cast entity).collect(player);

        // Enemy collision
        else if (Std.is(entity, Enemy))
            (cast entity).interact(player);

        // Must be a kill tile! loool
        else
        {
            player.health = 0;
            player.kill();
        }
    }
}
