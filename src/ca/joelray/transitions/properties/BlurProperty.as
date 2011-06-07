/**
 * BlurProperty by Joel Ray. 2011
 *
 * Copyright (c) 2011 Joel Ray
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 **/
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
		private static var _target:*;
		
		// Properties
		private static var _args:Array = new Array("blurX", "blurY", "quality");
		private static var _blurStart:Array;
		private static var _blurDiff:Array;
		
		
		// =========================================================================================================
		// PUBLIC STATIC INTERFACE ---------------------------------------------------------------------------------
		
		public static function register():void {
			BasicTween.registerSpecialProperty("_blur", BlurProperty);
		};
		
		public static function init($target:*, $finalValue:*):void {
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
		
		public static function update($progress:Number):void {
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