package ca.joelray.transitions.properties {
	
	import ca.joelray.transitions.BasicTween;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	public class ColorProperty {
		
		// Instances
		private var _target:*;
		
		// Properties
		private var _args:Array = new Array("redMultiplier", "greenMultiplier", "blueMultiplier", "redOffset", "greenOffset", "blueOffset");
		private var _colorStart:Array;
		private var _colorDiff:Array;
		private var _progress:Number;
		
		
		// =========================================================================================================
		// PUBLIC STATIC INTERFACE ---------------------------------------------------------------------------------
		
		public static function register():void {
			BasicTween.registerSpecialProperty("_color", ColorProperty);
		};
		
		
		// =========================================================================================================
		// PUBLIC INTERFACE ----------------------------------------------------------------------------------------
		
		public function init($target:*, $finalValue:*):void {
			_target = $target;
			_colorStart = new Array();
			_colorDiff = new Array();
			
			var currentCT:ColorTransform = (_target as DisplayObject).transform.colorTransform;
			var finalCT:ColorTransform = new ColorTransform();
			if($finalValue != null) finalCT.color = ($finalValue as uint);
			
			var arg:String;
			for each(arg in _args) {
				_colorStart[ arg ] = currentCT[ arg ];
				_colorDiff[ arg ] = finalCT[ arg ] - _colorStart[ arg ];
			}
		};
		
		public function update($progress:Number):void {
			
			var ct:ColorTransform = (_target as DisplayObject).transform.colorTransform;
			var arg:String
			for each(arg in _args) {
				_progress = _colorStart[arg] + (_colorDiff[arg] * $progress);
				ct[arg] = _progress;
			}
			
			(_target as DisplayObject).transform.colorTransform = ct;
		};
	}
}