package ca.joelray.transitions.properties {
	import ca.joelray.transitions.BasicTween;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	/**
	 * BrightnessProperty.register();
	 * BasicTween.to(_object, 1, { _brightness:-.3 });
	 */	
	public class BrightnessProperty {
		
		// Instances
		private var _target:*;
		
		// Properties
		private var _start:Number;
		private var _diff:Number;
		private var _progress:Number;
		
		
		// =========================================================================================================
		// PUBLIC STATIC INTERFACE ---------------------------------------------------------------------------------
		
		public static function register():void {
			BasicTween.registerSpecialProperty("_brightness", BrightnessProperty);
		};
		
		
		// =========================================================================================================
		// PUBLIC INTERFACE ----------------------------------------------------------------------------------------
		
		public function init($target:*, $finalValue:*):void {
			_target = $target;
			
			var cfm:ColorTransform = (_target as DisplayObject).transform.colorTransform;
			var mc:Number = 1 - ((cfm.redMultiplier + cfm.greenMultiplier + cfm.blueMultiplier) / 3);
			var co:Number = (cfm.redOffset + cfm.greenOffset + cfm.blueOffset) / 3;
			
			_start = (co > 0) ? co / 255 : -mc;
			_diff = ($finalValue as Number) - _start;			
		};
		
		public function update($progress:Number):void {
			_progress = _start + (_diff * $progress);
			
			var mc:Number = 1 - Math.abs(_progress);
			var co:Number = (_progress > 0) ? Math.round(_progress * 255) : 0;
			
			var cfm:ColorTransform = new ColorTransform(mc, mc, mc, 1, co, co, co, 0);
			(_target as DisplayObject).transform.colorTransform = cfm;
		};
		
	};
};