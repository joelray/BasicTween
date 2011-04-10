/**
 * BrightnessProperty by Joel Ray. 2011
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
	import flash.geom.ColorTransform;
	
	/**
	 * BrightnessProperty.register();
	 * BasicTween.to(_object, 1, { _brightness:-.3 });
	 */	
	public class BrightnessProperty {
		
		// Instances
		private static var _target:*;
		
		// Properties
		private static var _start:Number;
		private static var _diff:Number;
		private static var _progress:Number;
		
		
		// =========================================================================================================
		// PUBLIC STATIC INTERFACE ---------------------------------------------------------------------------------
		
		public static function register():void {
			BasicTween.registerSpecialProperty("_brightness", BrightnessProperty);
		};
		
		public static function init($target:*, $finalValue:*):void {
			_target = $target;
			
			var cfm:ColorTransform = (_target as DisplayObject).transform.colorTransform;
			var mc:Number = 1 - ((cfm.redMultiplier + cfm.greenMultiplier + cfm.blueMultiplier) / 3);
			var co:Number = (cfm.redOffset + cfm.greenOffset + cfm.blueOffset) / 3;
			
			_start = (co > 0) ? co / 255 : -mc;
			_diff = ($finalValue as Number) - _start;			
		};
		
		public static function update($progress:Number):void {
			_progress = _start + (_diff * $progress);
			
			var mc:Number = 1 - Math.abs(_progress);
			var co:Number = (_progress > 0) ? Math.round(_progress * 255) : 0;
			
			var cfm:ColorTransform = new ColorTransform(mc, mc, mc, 1, co, co, co, 0);
			(_target as DisplayObject).transform.colorTransform = cfm;
		};
		
	};
};