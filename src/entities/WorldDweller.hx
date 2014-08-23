package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import utils.Vector;

class WorldDweller extends Entity {
  public static inline var MAX_ACCELERATION_X:Float = 2;
  public static inline var MAX_ACCELERATION_Y:Float = 8;

  public static inline var AIR_DRAG:Float = 0.01;
  public static inline var GROUND_DRAG:Float = 0.2;

  public var grounded:Bool;

  public var _world:World;

  public var acceleration:Vector;


  /* ---------- HaxePunk Overrides ---------- */
 

  public function new(x:Float, y:Float) {
    super(x, y);

    acceleration = new Vector(0, 0);

    grounded = false;
  }
  
  public override function update() {
    super.update();

    doPhysics();
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

  public override function moveCollideY(entity:Entity):Bool {
    if (entity.type == "solid") {
      grounded = true;
    }
    return super.moveCollideY(entity);
  }

  /* ---------- Game Related Functions ---------- */


  public function doPhysics() {
    if (Math.abs(acceleration.x) > MAX_ACCELERATION_X) {
      acceleration.x = HXP.sign(acceleration.x) * MAX_ACCELERATION_X;
    }
    if (Math.abs(acceleration.y) > MAX_ACCELERATION_Y) {
      acceleration.y = HXP.sign(acceleration.y) * MAX_ACCELERATION_Y;
    }
    moveBy(acceleration.x, acceleration.y, "solid");
  }

  private function applyDrag() {
    if (Math.abs(acceleration.x) > 0) {
      acceleration.x += -HXP.sign(acceleration.x) * (grounded ?  GROUND_DRAG : AIR_DRAG);
      if (Math.abs(acceleration.x) <= GROUND_DRAG) {
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
