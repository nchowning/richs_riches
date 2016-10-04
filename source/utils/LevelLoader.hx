package utils;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

import enemies.Placeholder;
import objects.Coin;
import objects.Screen;
import objects.Warp;

class LevelLoader
{
    public static function loadLevel(level:String)
    {
        var tiledMap = new TiledMap("assets/data/" + level + ".tmx");

        FlxG.cameras.bgColor = tiledMap.backgroundColor;

        // Load backdrop layers
        setupBackdrops(tiledMap);

        // Load background tiles
        Reg.STATE.mapBackground = getTileLayer(tiledMap, "background");
        Reg.STATE.mapBackground.solid = false;

        // Platforms only collide from the top
        Reg.STATE.mapPlatforms = getTileLayer(tiledMap, "platforms");
        // Set all tiles on this layer to only collide on the top
        // TODO there has to be a better way to do this
        for (index in 0...(Reg.STATE.mapPlatforms.totalTiles - 1))
        {
            var tile = Reg.STATE.mapPlatforms.getTileByIndex(index);
            if (tile != 0)
                Reg.STATE.mapPlatforms.setTileProperties(tile, FlxObject.CEILING);
        }

        // Load collision tiles
        Reg.STATE.mapCollide = getTileLayer(tiledMap, "collide");

        // Load foreground tiles
        Reg.STATE.mapForeground = getTileLayer(tiledMap, "foreground");
        Reg.STATE.mapForeground.solid = false;

        // Load obtainable objects
        for (obtainable in getObjectLayer(tiledMap, "obtainables"))
        {
            switch(obtainable.type)
            {
                case "coin":
                    Reg.STATE.coins.add(new Coin(obtainable.x, obtainable.y - 8));
            }
        }

        // Load enemy objects
        for (enemy in getObjectLayer(tiledMap, "enemies"))
        {
            switch(enemy.type)
            {
                default:
                    Reg.STATE.enemies.add(new Placeholder(enemy.x, enemy.y - 6));
            }
        }

        // Load warps on the map
        for (warp in getObjectLayer(tiledMap, "warp"))
        {
            if (warp.properties.contains("warpToMap"))
            {
                Reg.STATE.warps.add(new Warp(warp.x, warp.y, warp.width, warp.height, warp.properties.get("warpToMap")));
            }
        }

        // Load 'screens' on the map
        for (screen in getObjectLayer(tiledMap, "screens"))
        {
            Reg.STATE.screens.add(new Screen(screen.x, screen.y, screen.width, screen.height));
        }

        // Set the player's start position
        var playerPos:TiledObject = getObjectLayer(tiledMap, "player")[0];
        Reg.STATE.player.setPosition(playerPos.x, playerPos.y - 15);
    }

    private static function setupBackdrops(map:TiledMap):Void
    {

        var backdropCount:Int = Std.parseInt(getMapProperty(map, "backdropCount", "0"));
        var backdropName:String = getMapProperty(map, "backdropName", "clouds");
        var backdropAutoScrollDirection:String = getMapProperty(map, "backdropAutoScrollDirection", "left");
        // TODO add auto scroll speed

        // If the count is 0, we have no backdrop
        if (backdropCount <= 0)
            return;

        for (i in 1...(backdropCount + 1))
        {
            var scrollSpeedX:Float;
            var scrollSpeedY:Float;
            var autoScrollSpeedX:Float;
            var autoScrollSpeedY:Float;
            var repeatX:Bool;
            var repeatY:Bool;

            switch (backdropAutoScrollDirection)
            {
                default:
                    // Scroll to the left
                    scrollSpeedX = i * 0.1;
                    scrollSpeedY = 0.0;
                    autoScrollSpeedX = i * -4;
                    autoScrollSpeedY = 0;
                    repeatX = true;
                    repeatY = false;
                case "up":
                    // Scroll upward
                    scrollSpeedX = i * 0.1;
                    scrollSpeedY = i * 0.1;
                    autoScrollSpeedX = 0;
                    autoScrollSpeedY = i * -4;
                    repeatX = true;
                    repeatY = true;
            }


            var backdrop = new FlxBackdrop("assets/images/backdrops/" + backdropName + i + ".png", scrollSpeedX, scrollSpeedY, repeatX, repeatY);

            // Auto-scroll speeds
            backdrop.velocity.x = autoScrollSpeedX;
            backdrop.velocity.y = autoScrollSpeedY;

            Reg.STATE.backdrops.add(backdrop);
        }
    }

    private static function getMapProperty(map:TiledMap, property:String, ?defaultValue = ""):String
    {
        if (map.properties.contains(property))
            return map.properties.get(property);

        if (defaultValue != "")
            return defaultValue;
        return "";
    }

    private static function getTileLayer(map:TiledMap, layer:String):FlxTilemap
    {
        var layer:TiledTileLayer = cast map.getLayer(layer);
        var tileMap:FlxTilemap = new FlxTilemap();
        tileMap.loadMapFromArray(
            layer.tileArray,
            map.width,
            map.height,
            AssetPaths.tiles__png,
            8, 8, 1);

        return tileMap;
    }

    private static function getObjectLayer(map:TiledMap, layer:String):Array<TiledObject>
    {
        if ((map != null) && (map.getLayer(layer) != null))
        {
            var objLayer:TiledObjectLayer = cast map.getLayer(layer);
            return objLayer.objects;
        }
        else
        {
            trace("Object layer " + layer + " not found!");
            return [];
        }
    }
}
