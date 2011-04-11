package ca.joelray.transitions.properties {
	
	import ca.joelray.transitions.BasicTween;
	
	import flash.media.SoundTransform;
	
	/**
	 * Volume tween of a SoundTransform object from a SoundChannel or MovieClip.
	 * 
	 * VolumeProperty.register();
	 * BasicTween.to(_soundChannel, 1, { _volume:0 }); 
	 */	
	
	public class VolumeProperty {
		
		// Instances
		private var _target:*;
		
		// Properties
		private var _start:Number;
		private var _diff:Number;
		private var _progress:Number;
		
		
		// =========================================================================================================
		// PUBLIC STATIC INTERFACE ---------------------------------------------------------------------------------
		
		public static function register():void {
			BasicTween.registerSpecialProperty("_volume", VolumeProperty);
		};
		
		
		// =========================================================================================================
		// PUBLIC INTERFACE ----------------------------------------------------------------------------------------
		
		public function init($target:*, $finalValue:*):void {
			_target = $target;
			_start = (_target["soundTransform"] as SoundTransform).volume;
			_diff = ($finalValue as Number) - _start;
		};
		
		public function update($progress:Number):void {
			var st:SoundTransform = _target["soundTransform"];
			_progress = _start + (_diff * $progress);
			st.volume = _progress;
			
			_target["soundTransform"] = st;
		};
		
	};
};