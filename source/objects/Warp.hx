package objects;

import flixel.FlxG;
import flixel.FlxSprite;

import states.PlatformState;

class Warp extends FlxSprite
{
    private var _level:String;

    public function new(x:Float, y:Float, level:String)
    {
        super(x, y);

        _level = level;
    }

    public function warpToLevel()
    {
        Reg.LEVEL = _level;
        FlxG.switchState(new PlatformState());
    }
}