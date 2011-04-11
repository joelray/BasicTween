/**
 * BasicTweenSignal by Joel Ray. 2010
 *
 * Copyright (c) 2010 Joel Ray
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
package ca.joelray.transitions {
	
	/**
	 * The <code>BasicTweenSignal</code> Class
	 * 
	 * @copyright 		2010 Joel Ray
	 * @author			Joel Ray
	 * @version			1.0 
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 10.0.0
	 */
	public class BasicTweenSignal {
		
		private var _functions      : Vector.<Function>;
		private var _length         : int = 0;
		private var _i              : int;

		
		// ===========================================================================================================================
		// CONSTRUCTOR ---------------------------------------------------------------------------------------------------------------
		
		public function BasicTweenSignal() {
			_functions = new Vector.<Function>();
		};


		// ===========================================================================================================================
		// PUBLIC interface ----------------------------------------------------------------------------------------------------------
		
		public function add( $function:Function ):Boolean {
			if( _functions.indexOf( $function ) == -1 ) {
				_functions.push( $function );
				_length = _functions.length;
				return true;
			}
			return false;
		};

		public function remove( $function:Function ):Boolean {
			if( _functions.indexOf( $function ) == -1 ) {
				_functions.splice( _functions.indexOf( $function ), 1 );
				_length = _functions.length;
				return true;
			}
			return false;
		};
		
		public function dispatch():void {
			for( _i=0; _i<_length; ++_i ) { _functions[ _i ](); }
		};
	};
};
