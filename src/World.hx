

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;

import entities.WorldDweller;

import utils.Vector;

class World extends Entity {
  public static inline var DEFAULT_GRAVITY:Float = 1;

  public static inline var LIGHT:Int = 0xFFFFFF;
  public static inline var DARK:Int = 0x000000;

  public var children:Array<WorldDweller>;
  public var gravity:Vector;
  public var color(default, set):Int;

  public var receiveEvents:Bool;


  /* ---------- HaxePunk Overrides ---------- */

 
  public function new(x:Float, y:Float, width:Int, height:Int) {
    super(x, y);

    this.width = width;
    this.height = height;

    children = new Array<WorldDweller>();

    gravity = new Vector(0, DEFAULT_GRAVITY);

    receiveEvents = false;
  }

  public override function update() {
    if (receiveEvents) {
    }

    for (child in children) {
      child.update();
    }
  }

  public override function added() {
    for (child in children) {
      scene.add(child);
    }
    doPhysics();
  }


  /* ---------- Child Management Functions ---------- */


  public function addChild(child:WorldDweller) {
    children.push(child);
    child.assignWorld(this);
  }

  public function removeChild(child:WorldDweller) {
    children.remove(child);
    child._world = null;
    scene.remove(child);
  }


  /* ---------- Game Related Functions ---------- */


  private function doPhysics() {
    for (child in children) {
      child.applyGravity(gravity);
    }
  }

  public function getInverse():Int {
    if (color == LIGHT) {
      return DARK;
    }
    return LIGHT;
  }


  /* ---------- Getters/Setters ---------- */
  

  public function set_color(color:Int):Int {
    this.color = color;

    for (child in children) {
      child.assignWorld(this);
    }

    graphic = Image.createRect(width, height, color);

    return color;
  }
}
