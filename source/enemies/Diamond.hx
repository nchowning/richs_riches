package enemies;

class Diamond extends Enemy
{
    public function new(x:Float, y:Float)
    {
        super(x, y);

        _walkSpeed = 40;

        loadGraphic("assets/images/enemies/diamond.png", true, 16, 16);
        animation.add("idle", [0]);
        animation.add("walk", [0, 1, 2, 1, 0, 3, 4, 3], 7);
        animation.add("death", [5, 6, 7], 7, false);
        animation.play("walk");

        setSize(12, 13);
        offset.set(2, 3);
    }

    override private function move()
    {
        velocity.x = _walkSpeed * _direction;
    }
}