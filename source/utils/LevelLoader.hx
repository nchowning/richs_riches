package utils;

import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.tile.FlxTilemap;

import enemies.Placeholder;
import objects.Coin;

class LevelLoader
{
    public static function loadLevel(level:String)
    {
        var tiledMap = new TiledMap("assets/data/" + level + ".tmx");

        // Load backdrop images
        var backdropName:String = getMapProperty(tiledMap, "backdropName");
        var backdropCount:Int = Std.parseInt(getMapProperty(tiledMap, "backdropCount"));

        for (i in 1...(backdropCount + 1))
        {
            // The player movement initiated scroll speeds
            var backdropScrollSpeedX:Float = i * 0.1;
            var backdropScrollSpeedY:Float = 0.0;

            var backdrop = new FlxBackdrop("assets/images/backdrops/" + backdropName + i + ".png", backdropScrollSpeedX, backdropScrollSpeedY, true, false);

            // Auto-scroll speeds
            backdrop.velocity.x = i * -4;
            backdrop.velocity.y = 0;

            Reg.STATE.backdrops.add(backdrop);
        }

        // Load background tiles
        Reg.STATE.mapBackground = getTileLayer(tiledMap, "background");
        Reg.STATE.mapBackground.solid = false;

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

        // Set the player's start position
        var playerPos:TiledObject = getObjectLayer(tiledMap, "player")[0];
        Reg.STATE.player.setPosition(playerPos.x, playerPos.y - 15);
    }

    private static function getMapProperty(map:TiledMap, property:String):String
    {
        if (map.properties.contains(property))
            return map.properties.get(property);
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
