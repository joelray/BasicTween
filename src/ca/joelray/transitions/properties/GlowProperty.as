package ca.joelray.transitions.properties {
	
	import ca.joelray.transitions.BasicTween;
	
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter; // delete
	import flash.filters.GlowFilter;
	
	/**
	 * EX.
	 * GlowProperty.register();
	 * BasicTween.to(_object, 1, { _glow:{blurX:40, blurY:40, quality:3}, ease:Strong.easeInOut });
	 */	
	
	public class GlowProperty {
		
		// Instances
		private var _target:*;
		
		// Properties
		private var _args:Array = new Array("color", "alpha", "blurX", "blurY", "strength", "quality", "inner", "knockout");
		private var _glowStart:Array;
		private var _glowDiff:Array;
		
		
		// =========================================================================================================
		// PUBLIC STATIC INTERFACE ---------------------------------------------------------------------------------
		
		public static function register():void {
			BasicTween.registerSpecialProperty("_glow", GlowProperty);
		};
		
		
		// =========================================================================================================
		// PUBLIC INTERFACE ----------------------------------------------------------------------------------------
		
		public function init($target:*, $finalValue:*):void {
			_target = $target;
			
			var foundIndex:int = -1;
			var filters:Array = (_target as DisplayObject).filters;
			
			for(var i:uint = 0;i < filters.length; i++){
				if(filters[i] is GlowFilter){
					foundIndex = i;
					break;
				}
			}
			
			var glow:GlowFilter = (foundIndex > -1) ? filters[foundIndex] : new GlowFilter();
			
			_glowStart = new Array();
			_glowDiff = new Array();
			
			var arg:String;
			for each(arg in _args) {
				if($finalValue[ arg ] != null){
					_glowStart[ arg ] = glow[ arg ];
					_glowDiff[ arg ] = $finalValue[ arg ] - _glowStart[ arg ];
				} 
			}
			
			// Apply blur filter if it did not exist before
			if(foundIndex == -1){
				filters.push(glow);
				(_target as DisplayObject).filters = filters;
			}
		};
		
		public function update($progress:Number):void {
			var filters:Array = (_target as DisplayObject).filters;
			for(var i:uint = 0;i < filters.length; i++){
				if(filters[i] is GlowFilter){
					var arg:String;
					for each(arg in _args) {
						if( _glowStart[ arg ] != null ){
							var n:Number = _glowStart[arg] + (_glowDiff[arg] * $progress);
							filters[i][arg] = n;
						} 
					}
					
					break;
				}
			}
			
			(_target as DisplayObject).filters = filters;
		};
		
	};
};