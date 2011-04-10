/**
 * VolumeProperty by Joel Ray. 2011
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
	
	import flash.media.SoundTransform;
	
	/**
	 * Tweens the volume of a SoundTransform object from a SoundChannel or MovieClip.
	 * 
	 * VolumeProperty.register();
	 * BasicTween.to(_soundChannel, 1, { _volume:0 }); 
	 */	
	
	public class VolumeProperty {
		
		// Instances
		private static var _target:*;
		
		// Properties
		private static var _start:Number;
		private static var _diff:Number;
		private static var _progress:Number;
		
		
		// =========================================================================================================
		// PUBLIC STATIC INTERFACE ---------------------------------------------------------------------------------
		
		public static function register():void {
			BasicTween.registerSpecialProperty("_volume", VolumeProperty);
		};
		
		public static function init($target:*, $finalValue:*):void {
			_target = $target;
			_start = (_target["soundTransform"] as SoundTransform).volume;
			_diff = ($finalValue as Number) - _start;
		};
		
		public static function update($progress:Number):void {
			var st:SoundTransform = _target["soundTransform"];
			_progress = _start + (_diff * $progress);
			st.volume = _progress;
			
			_target["soundTransform"] = st;
		};
		
	};
};