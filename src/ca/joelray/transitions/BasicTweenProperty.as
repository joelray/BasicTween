/**
 * BasicTweenProperty by Joel Ray. 2010
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
	 * The <code>BasicTweenProperty</code> Class
	 * 
	 * @copyright 		2010 Joel Ray
	 * @author			Joel Ray
	 * @version			1.0 
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 10.0.0
	 *
	 */
	public class BasicTweenProperty {
		
		public var id                       : String;
		
		public var valueStart               : *;           // Starting value
		public var valueComplete            : *;           // Final Value
		public var valueChange              : *;           // Change needed in value (cache)
		
		public var isSpecialProperty        : Boolean;
		public var specialProperty          : *;
		
		
		// ===========================================================================================================================
		// CONSTRUCTOR ---------------------------------------------------------------------------------------------------------------
		
		public function BasicTweenProperty( $id:String, $valueComplete:*, $specialProperty:* = null ) {
			id = $id;
			valueComplete = $valueComplete;
			
			if(Boolean($specialProperty)) {
				isSpecialProperty = true;
				specialProperty = $specialProperty;
			}
		};
		
	};
};
