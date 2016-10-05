package;

import flixel.FlxState;
import flixel.input.keyboard.FlxKey;

import states.PlatformState;

class Reg
{
    public static var STATE:PlatformState;
    public static var LEVEL:String = "map1";
    public static var PAUSE:Bool = false;

    public static var MONEY:Int = 0;

    public static var inputMap:Map<String, Int> = [
        "left"  => FlxKey.LEFT,
        "right" => FlxKey.RIGHT,
        "up"    => FlxKey.UP,
        "down"  => FlxKey.DOWN,
        "b"     => 0,
        "a"     => FlxKey.SPACE,
    ];
}
