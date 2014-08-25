import utils.MessageBus;

import com.haxepunk.Engine;
import com.haxepunk.HXP;

import scenes.TitleScene;
import scenes.GameScene;
import scenes.WinScene;

class Main extends Engine {
  private static inline var MAIN_SCENESWITCH:String = "main_sceneswitch";

  public var messageBus:MessageBus;

  public var currentLevel:String;

	override public function init() {

#if debug
		HXP.console.enable();
#end

    currentLevel = LevelManager.nextLevel("");

    messageBus = new MessageBus();

    messageBus.subscribe(MessageBus.SCENE_SWITCH, MAIN_SCENESWITCH, sceneSwitch);

		HXP.scene = new TitleScene(messageBus);
	}

  private function sceneSwitch(message:String):Bool {
    if (message == "menu") {
      HXP.scene = new GameScene(currentLevel, messageBus, true);
    } else if (message == "gameoverLight") {
      HXP.scene = new GameScene(currentLevel, messageBus, true);
    } else if (message == "gameoverDark") {
      HXP.scene = new GameScene(currentLevel, messageBus, false);
    } else if (message == "win") {
      currentLevel = LevelManager.nextLevel(currentLevel);
      if (currentLevel != "") {
        HXP.scene = new GameScene(currentLevel, messageBus, true);
      } else {
        HXP.scene = new WinScene(messageBus);
      }
    }

    return true;
  }

	public static function main() { new Main(); }

}
