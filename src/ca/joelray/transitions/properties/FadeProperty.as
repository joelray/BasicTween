package ca.joelray.transitions.properties {
	
	import ca.joelray.transitions.BasicTween;
	
	import flash.display.DisplayObject;
	
	/**
	 * A smarter way of fading the alpha property.
	 * 
	 * FadeProperty.register();
	 * BasicTween.to(_object, 1, { _fade:0 }); 
	 */	
	
	public class FadeProperty {
		
		// Instances
		private var _target:*;
		
		// Properties
		private var _start:Number;
		private var _diff:Number;
		private var _progress:Number;
		
		
		// =========================================================================================================
		// PUBLIC STATIC INTERFACE ---------------------------------------------------------------------------------
		
		public static function register():void {
			BasicTween.registerSpecialProperty("_fade", FadeProperty);
		};
		
		
		// =========================================================================================================
		// PUBLIC INTERFACE ----------------------------------------------------------------------------------------
		
		public function init($target:*, $finalValue:*):void {
			_target = $target;
			_start = (_target as DisplayObject).alpha;
			_diff = ($finalValue as Number) - _start;
		};
		
		public function update($progress:Number):void {
			_progress = _start + (_diff * $progress);
			(_target as DisplayObject).alpha = _progress;
			(_target as DisplayObject).visible = ((_target as DisplayObject).alpha > 0);
		};
		
	};
};