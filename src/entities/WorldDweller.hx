package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import utils.Vector;

class WorldDweller extends Entity {
  public var _world:World;

  public var acceleration:Vector;


  /* ---------- HaxePunk Overrides ---------- */
 

  public function new(x:Float, y:Float) {
    super(x, y);

    acceleration = new Vector(0, 0);
  }
  
  public override function update() {
    super.update();

    applyPhysics();
  }

  public override function render() {
    if (_world.color == World.DARK) {
      graphic.x = x;
      var baseY = y - _world.y;
      graphic.y = _world.height - baseY + _world.y - height;
      super.render();
    } else {
      super.render();
    }
  }

  /* ---------- Game Related Functions ---------- */


  public function applyPhysics() {
    moveBy(acceleration.x, acceleration.y, "solid");
  }

  private function applyDrag() {
    if (Math.abs(acceleration.x) > 0) {
      acceleration.x += -HXP.sign(acceleration.x) * 0.1;
      if (Math.abs(acceleration.x) <= 0.1) {
        acceleration.x = 0;
      }
    } 
  }

  public function applyGravity(gravity:Vector) {
    acceleration.add(gravity);
  }

  //Assign a color to the sprite based on the color of the world
  public function assignWorld(_world:World) {
    graphic = Image.createRect(Std.int(width), Std.int(height), _world.getInverse());

    if (_world.color == World.DARK) {
      graphic.relative = false;
    }

    moveBy(_world.x, _world.y);

    this._world = _world;
  }
}
