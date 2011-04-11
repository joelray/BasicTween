package ca.joelray.transitions.properties {
	import ca.joelray.transitions.BasicTween;
	
	import flash.display.MovieClip;
	
	public class FrameProperty {
		
		// Instances
		private var _target:*;
		
		// Properties
		private var _start:Number;
		private var _diff:Number;
		private var _progress:Number;
		
		
		// =========================================================================================================
		// PUBLIC STATIC INTERFACE ---------------------------------------------------------------------------------
		
		public static function register():void {
			BasicTween.registerSpecialProperty("_frame", FrameProperty);
		};
		
		
		// =========================================================================================================
		// PUBLIC INTERFACE ----------------------------------------------------------------------------------------
		
		public function init($target:*, $finalValue:*):void {
			_target = $target;
			_start = (_target as MovieClip).currentFrame;
			_diff = ($finalValue as Number) - _start;	
		};
		
		public function update($progress:Number):void {
			_progress = _start + (_diff * $progress);
			_progress = Math.round(_progress);
			
			if(_progress >= 1 && _progress <= (_target as MovieClip).totalFrames) (_target as MovieClip).gotoAndStop(_progress);			
			else throw new Error("Frame Tween error, invalid frame value");
		};
		
	};
};