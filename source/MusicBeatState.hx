package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;

class MusicBeatState extends FlxUIState
{
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var curSection:Int = 0;

	private var controls(get, never):Controls;
	function get_controls():Controls
		return PlayerSettings.player1.controls;

	private function setDefaultTransitions(asset:flixel.graphics.FlxGraphic)
	{
		asset.persist = true;
		asset.destroyOnNoUse = false;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, flixel.util.FlxColor.BLACK, 1, new flixel.math.FlxPoint(0, -1), 
		{
			asset: asset,
			width: 32,
			height: 32
		}, new flixel.math.FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, flixel.util.FlxColor.BLACK, 0.7, new flixel.math.FlxPoint(0, 1),
		{
			asset: asset,
			width: 32,
			height: 32
		}, new flixel.math.FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
	}

	override function create()
	{
		if (FlxTransitionableState.defaultTransIn == null && FlxTransitionableState.defaultTransOut == null)
		{
			var diamond:flixel.graphics.FlxGraphic = flixel.graphics.FlxGraphic.fromClass(flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond);
			setDefaultTransitions(diamond);
		}
		
		#if debug if (transIn != null) trace('reg ' + transIn.region); #end

		#if flash openfl.system.System.gc(); #end

		super.create();
	}

	override function update(elapsed:Float)
	{
		var oldStep:Int = curStep;

		updateStep();
		updateBeat();
		updateSec();

		if (oldStep != curStep && curStep >= 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}
	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}
	private function updateSec():Void
	{
		curSection = Math.floor(curStep / 16);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();

		if (curStep % 16 == 0)
			sectionHit();
	}

	public function beatHit():Void
	{
		// do literally nothing dumbass
	}

	public function sectionHit():Void
	{
		// do literally nothing dumbass 2
	}
}
