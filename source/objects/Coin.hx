package objects;

import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Coin extends Obtainable
{
    private static var VALUE:Int = 100;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        loadGraphic(AssetPaths.coin__png, true, 8, 8);

        animation.add("idle", [0, 1, 2, 3, 4, 5], 7);
        animation.play("idle");

        setSize(6, 6);
        offset.set(1, 1);
    }

    override public function collect(player:Player)
    {
        player.heal(1.0);
        kill();
    }
}
