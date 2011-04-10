/**
 * FadeProperty by Joel Ray. 2011
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
	
	/**
	 * A smarter way of fading the alpha property.
	 * 
	 * FadeProperty.register();
	 * BasicTween.to(_object, 1, { _fade:0 }); 
	 */	
	
	public class FadeProperty {
		
		// Instances
		private static var _target:*;
		
		// Properties
		private static var _start:Number;
		private static var _diff:Number;
		private static var _progress:Number;
		
		
		// ===========================================================================================================================
		// PUBLIC STATIC INTERFACE ---------------------------------------------------------------------------------------------------
		
		public static function register():void {
			BasicTween.registerSpecialProperty("_fade", FadeProperty);
		};
		
		public static function init($target:*, $finalValue:*):void {
			_target = $target;
			_start = (_target as DisplayObject).alpha;
			_diff = ($finalValue as Number) - _start;
		};
		
		public static function update($progress:Number):void {
			_progress = _start + (_diff * $progress);
			(_target as DisplayObject).alpha = _progress;
			(_target as DisplayObject).visible = ((_target as DisplayObject).alpha > 0);
		};
		
	};
};