package ca.joelray.transitions.properties {
	
	import ca.joelray.transitions.BasicTween;
	
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	
	/**
	 * EX.
	 * BlurProperty.register();
	 * BasicTween.to(_object, 1, { _blur:{blurX:40, blurY:40, quality:3}, ease:Strong.easeInOut });
	 */	
	
	public class BlurProperty {
		
		// Instances
		private var _target:*;
		
		// Properties
		private var _args:Array = new Array("blurX", "blurY", "quality");
		private var _blurStart:Array;
		private var _blurDiff:Array;
		
		
		// =========================================================================================================
		// PUBLIC STATIC INTERFACE ---------------------------------------------------------------------------------
		
		public static function register():void {
			BasicTween.registerSpecialProperty("_blur", BlurProperty);
		};
		
		
		// =========================================================================================================
		// PUBLIC INTERFACE ----------------------------------------------------------------------------------------
		
		public function init($target:*, $finalValue:*):void {
			_target = $target;
			
			var foundIndex:int = -1;
			var filters:Array = (_target as DisplayObject).filters;
			
			for(var i:uint = 0;i < filters.length; i++){
				if(filters[i] is BlurFilter){
					foundIndex = i;
					break;
				}
			}
			
			var blur:BlurFilter = (foundIndex > -1) ? filters[foundIndex] : new BlurFilter(0, 0);
			
			_blurStart = new Array();
			_blurDiff = new Array();
			
			var arg:String;
			for each(arg in _args) {
				if($finalValue[ arg ] != null){
					_blurStart[ arg ] = blur[ arg ];
					_blurDiff[ arg ] = $finalValue[ arg ] - _blurStart[ arg ];
				} 
			}
			
			// Apply blur filter if it did not exist before
			if(foundIndex == -1){
				filters.push(blur);
				(_target as DisplayObject).filters = filters;
			}
		};
		
		public function update($progress:Number):void {
			var filters:Array = (_target as DisplayObject).filters;
			for(var i:uint = 0;i < filters.length; i++){
				if(filters[i] is BlurFilter){
					var arg:String;
					for each(arg in _args) {
						if( _blurStart[ arg ] != null ){
							var n:Number = _blurStart[arg] + (_blurDiff[arg] * $progress);
							filters[i][arg] = n;
						} 
					}
					
					break;
				}
			}
			
			(_target as DisplayObject).filters = filters;
			
			// TODO if progress == 1 and blurX and blurY are 0, trash the filter. 
			// Actually, progress == 1 might be triggered too early if we use elastic easing so this is the wrong approach. 
			// Maybe there should be an extra argument end = true or another method altogether that's called on the last frame
		};
		
	};
};