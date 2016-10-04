package objects;

import flixel.FlxG;
import flixel.FlxObject;

import states.PlatformState;

class Warp extends FlxObject
{
    private var _level:String;

    public function new(x:Float, y:Float, width:Float, height:Float, level:String)
    {
        super(x, y, width, height);

        _level = level;
    }

    public function warpToLevel()
    {
        Reg.LEVEL = _level;
        FlxG.switchState(new PlatformState());
    }
}