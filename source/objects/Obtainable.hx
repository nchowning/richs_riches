package objects;

import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Obtainable extends FlxSprite
{
    private static var VALUE:Int = 1;

    public function new(x:Float, y:Float)
    {
        super(x, y);
    }

    override public function update(elapsed:Float)
    {
        if (!Reg.PAUSE)
            super.update(elapsed);
    }

    public function collect()
    {
        Reg.MONEY += VALUE;
        kill();
    }
}
