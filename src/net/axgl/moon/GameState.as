package net.axgl.moon {
	import io.arkeus.tiled.TiledMap;
	import io.arkeus.tiled.TiledReader;
	
	import net.axgl.lib.cycle.TimeCycleEngine;
	import net.axgl.lib.cycle.TimeCycleLightCurve;
	import net.axgl.lib.cycle.TimeCycleLightSequence;
	import net.axgl.moon.assets.Map;
	import net.axgl.moon.assets.Registry;
	import net.axgl.moon.assets.Resource;
	import net.axgl.moon.ui.TimeDisplay;
	import net.axgl.moon.world.World;
	
	import org.axgl.Ax;
	import org.axgl.AxState;
	import org.axgl.input.AxKey;
	import org.axgl.plus.message.AxMessage;

	public class GameState extends AxState {
		private var world:World;
		private var timeDisplay:TimeDisplay;
		
		private static var blah:Array = [];
		
		override public function create():void {
			Ax.background.hex = 0xffff0000;
			var map:TiledMap = new TiledReader().loadFromEmbedded(Map.WORLD);
			this.add(world = new World().build(map));
			Ax.camera.follow(world.player);
			//Ax.background.hex = 0xffffffff;
			
			Registry.game = this;
			Registry.player = world.player;
			
			var cycle:TimeCycleEngine = new TimeCycleEngine(0, 18000, new TimeCycleLightSequence(
				[[0, 0], [6, 0], [10, 0.25], [18, 0]],
				[[0, 0], [6, 0], [8, 0.25], [12, 0]],
				[[6, 0.1], [8, 0], [18, 0.1]],
				[[9, 0.5], [10, 0.5], [12, 0.5], [18, 0], [20, 0.5]]
			));
			this.add(cycle);
			this.add(timeDisplay = new TimeDisplay(4, Ax.viewHeight - TimeDisplay.HEIGHT - 2, cycle));
			
			var c:TimeCycleLightCurve = new TimeCycleLightCurve([[0, 0.5], [12, 0], [24, 1]]);
			//trace(c.getIntensity(0), c.getIntensity(12), c.getIntensity(24));
		}
		
		override public function update():void {
			if (Ax.keys.pressed(AxKey.SPACE)) {
				world.collision.setGraphic(Resource.COLLISION_TILESET_RED);
				AxMessage.show(["This is a message", "And this"]);
			}
			
			super.update();
			
			Ax.collide(world.player, world.collision);
		}
	}
}
