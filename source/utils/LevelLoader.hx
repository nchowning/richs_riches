package utils;

import flixel.FlxG;
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
