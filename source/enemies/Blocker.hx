package enemies;

import objects.Player;

class Blocker extends Enemy
{

    public function new(x:Float, y:Float, width:Float, height:Float)
    {
        super(x, y);
        setSize(width, height);

        // loool dirty hack
        alpha = 0.0;
        moves = false;
        immovable = true;
    }

    override public function interact(player:Player) {}
}