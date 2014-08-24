package entities;

import utils.MessageBus;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import flash.geom.Point;

class WorldDweller extends Entity {
  public static inline var MAX_ACCELERATION_X:Float = 2;
  public static inline var MAX_ACCELERATION_Y:Float = 8;

  public static inline var GRAVITY_X:Float = 0;
  public static inline var GRAVITY_Y:Float = 0.2;

  public static inline var AIR_DRAG:Float = 0.01;
  public static inline var GROUND_DRAG:Float = 0.2;

  public var grounded:Bool;

  public var _world:World;

  public var acceleration:Point;

  private var messageBus:MessageBus;

  public var light:Bool;

  public var baseTypename:String;


  /* ---------- HaxePunk Overrides ---------- */
 

  public function new(x:Float, y:Float, messageBus:MessageBus) {
    super(x, y);

    acceleration = new Point(0, 0);

    this.messageBus = messageBus;

    layer = 1;

    grounded = false;

    baseTypename = "";

    light = true;

    type = getTypename();
  }
  
  public override function update() {
    doPhysics();

    super.update();
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


  public function doPhysics() {
    if (Math.abs(acceleration.x) > MAX_ACCELERATION_X) {
      acceleration.x = HXP.sign(acceleration.x) * MAX_ACCELERATION_X;
    }
    if (Math.abs(acceleration.y) > MAX_ACCELERATION_Y) {
      acceleration.y = HXP.sign(acceleration.y) * MAX_ACCELERATION_Y;
    }

    if (x - originX + acceleration.x < _world.x) {
      moveTo(_world.x + originX, y);
      acceleration.x = 0;
    } else if (x - originX + acceleration.x + width > _world.x + _world.width) {
      moveTo(_world.x + _world.width - width + originX, y);
      acceleration.x = 0;
    }

    if (y + acceleration.y < _world.y) {
    } else if (y + acceleration.y > _world.y + _world.height) {
      acceleration.y = 0;
      die();
      return;
    }

    moveBy(acceleration.x, acceleration.y, getTypename("solid"));

    if (collide(getTypename("solid"), x, y + GRAVITY_Y) != null) {
      grounded = true;
      acceleration.y = 0;
    } else {
      grounded = false;
      applyGravity();
    }
  }

  public function die() { }

  private function applyDrag() {
    if (Math.abs(acceleration.x) > 0) {
      acceleration.x += -HXP.sign(acceleration.x) * (grounded ?  GROUND_DRAG : AIR_DRAG);
      if (Math.abs(acceleration.x) <= GROUND_DRAG) {
        acceleration.x = 0;
      }
    } 
  }

  public function applyGravity() {
    acceleration.x += GRAVITY_X;
    if (!grounded) {
      acceleration.y += GRAVITY_Y;
    }
  }

  //Assign a color to the sprite based on the color of the world
  public function assignWorld(_world:World) {
    setupGraphics(_world.color, _world.getInverse());

    light = true;

    if (_world.color == World.DARK) {
      graphic.relative = false;
      light = false;
    }

    type = getTypename();

    moveBy(_world.x, _world.y);

    this._world = _world;
  }

  public function setupGraphics(color:Int, inverseColor:Int) {
    graphic = Image.createRect(Std.int(width), Std.int(height), inverseColor);
  }

  public function getTypename(?name:String) {
    if (name == null) {
      name = baseTypename;
    }
    return name + (light ? "_light" : "_dark");
  }
}
