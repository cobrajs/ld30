import utils.MessageBus;

import com.haxepunk.Engine;
import com.haxepunk.HXP;

import scenes.GameScene;

class Main extends Engine {
  private static inline var MAIN_SCENESWITCH:String = "main_sceneswitch";

  public var messageBus:MessageBus;

	override public function init() {

#if debug
		HXP.console.enable();
#end

    messageBus = new MessageBus();

    messageBus.subscribe(MessageBus.SCENE_SWITCH, MAIN_SCENESWITCH, sceneSwitch);

		HXP.scene = new GameScene("world1", messageBus);
	}

  private function sceneSwitch(message:String):Bool {
    HXP.scene = new GameScene("world1", messageBus);
    return true;
  }

	public static function main() { new Main(); }

}
