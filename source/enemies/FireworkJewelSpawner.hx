package enemies;

import Type;

import objects.Player;

class FireworkJewelSpawner extends Enemy
{
    private var spawnedEnemy:FireworkJewel;
    private var timeBetweenSpawns:Float = 2.0;
    private var timeSinceSpawn:Float = 0.0;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        setSize(8, 8);

        // TODO add a graphic for spawner?
        alpha = 0.0;
        moves = false;
        immovable = true;
        solid = false;

        spawnedEnemy = new FireworkJewel(x - 4, y);
        Reg.STATE.enemies.add(spawnedEnemy);
    }

    override public function update(elapsed:Float):Void
    {
        if (!Reg.PAUSE)
        {
            if (!spawnedEnemy.alive && timeSinceSpawn > timeBetweenSpawns)
            {
                timeSinceSpawn = 0.0;
                spawnedEnemy.spawn(x - 4, y);
            }

            timeSinceSpawn += elapsed;
            super.update(elapsed);
        }
    }

    override public function interact(player:Player) {}
}