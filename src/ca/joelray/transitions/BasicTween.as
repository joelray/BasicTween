/**
 * BasicTween by Joel Ray. 2010
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
	
	import ca.joelray.transitions.easing.Linear;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	* The <code>BasicTween</code> Class
	* 
	* @copyright        2010 Joel Ray
	* @author           Joel Ray
	* @version          1.0 
	* @langversion      ActionScript 3.0 			
	* @playerversion    Flash 10.0.0
	*/
	public class BasicTween
	{
		
		public static var currentTime                   : int;                              // Current time in miliseconds 
		public static var currentTimeFrame              : int;                              // Current time in frames
                                                		
		private static var __eventContainer             : Sprite;                           // Tween engine container
		private static var __tweens                     : Vector.<BasicTween> = new Vector.<BasicTween>(); // List of tweens
		
		private static var _init                        : Boolean;                          // Acknowledges the tween has initialized
		private static var _keywords                    : Array = ["ease", "delay", "onStart", "onUpdate", "onComplete"]; // List of internal BasicTween properties - filtered out of "_properties" 
		private static var _specialProperties           : Array = [];                       // List of registered special properties
		private static var _specialPropertiesList       : Object;                           // List of special property instances

		private var _target                             : Object;                           // Display object being tweened
		private var _properties                         : Vector.<BasicTweenProperties>;    // Property instance
		private var _numProps                           : int;                              // Number of properties for a tween 
		private var _tProperty                          : BasicTweenProperties;             // Property being checked
		private var _pv                                 : Number;                           // Property value
		
		private var _t                                  : Number;                           // Current time (0-1)
		private var _cTime                              : int;                              // Current engine time (in frames or seconds)
		private var _timeStart                          : int;                              // Time when the tween will begin
		private var _timeCreated                        : int;                              // Time when the tween was created
		private var _timeComplete                       : int;                              // Time when the tween will end
		private var _timeDuration                       : int;                              // Duration of the tween
		private var _timePaused                         : int;                              // Duration of how long the tween has been paused
		private var _started                            : Boolean;                          // Acknowledges the tween has begun
		private var _ease                               : Function = Linear.easeNone;       // Tween ease - defaults to Linear.none
                                                		
		private var _onStart                            : BasicTweenSignal;              // Signal dispatched when a tween has started
		private var _onUpdate                           : BasicTweenSignal;              // Signal dispatched when a tween has updated
		private var _onComplete                         : BasicTweenSignal;              // Signal dispatched when a tween has completed  
                                                		
		private var _paused                             : Boolean;                          // Pauses all tweens
		private var _useFrames                          : Boolean;                          // Uses frames instead of milliseconds


		// ===========================================================================================================================
		// CONSTRUCTOR ---------------------------------------------------------------------------------------------------------------

		/**
		 *  The <code>BasicTween()</code> method creates a new tween.
		 *
		 *  @param     $target      Object      DisplayObject to be tweened.
		 *  @param     $time        Number      Length of tween time.
		 *  @param     $vars        Object      Paramters(x, y, delay, ease, etc.)
		 */
		public function BasicTween( $target:Object, $time:Number, $vars:Object = null ) {
			// Start the engine
			if(!_init) _initialize();
			
			_target = $target;
			_properties = new Vector.<BasicTweenProperties>();
			
			var i:String, k:String, sp:String, b:Boolean, issp:Boolean;
			for( i in $vars ) {
				b = false; issp = false;
				
				for each(k in _keywords) { if(i == k) { b = true; break; }} // Is this a internal BasicTween property?
				for each(sp in _specialProperties) { if(i == sp) { issp = true; break; }} // Is this a special property?

				if(!Boolean(b)) {
					// If property is special, mark it as so. Otherwise, push it as normal. 
					if(Boolean(issp)) _properties.push(new BasicTweenProperties( i, $vars[ i ], true));
					else _properties.push(new BasicTweenProperties( i, $vars[ i ]));
				}
			}

			_numProps = _properties.length;
			_timeCreated = currentTime;
			_timeStart = _timeCreated;

			// Parameters
			time = 0;
			delay = 0;
			
			// Signals
			_onStart = new BasicTweenSignal();
			_onUpdate = new BasicTweenSignal();
			_onComplete = new BasicTweenSignal();

			// Check parameters
			if($vars) {
				// time
				if( $time is Number && !isNaN( $time )) time = $time;
				
				// delay
				_pv = $vars[ "delay" ];
				if( _pv is Number && !isNaN( _pv )) delay = _pv;

				// ease, onStart, onUpdate, onComplete
				if( $vars[ "ease" ]) _ease = $vars[ "ease" ];
				if( $vars[ "onStart" ]) _onStart.add( $vars[ "onStart" ]);
				if( $vars[ "onUpdate" ]) _onUpdate.add( $vars[ "onUpdate" ]);
				if( $vars[ "onComplete" ]) _onComplete.add( $vars[ "onComplete" ]);
			}

			_useFrames = false;
			_paused = false;
			_started = false;
		};

		
		// ===========================================================================================================================
		// PUBLIC interface ----------------------------------------------------------------------------------------------------------
		
		/**
		 *  The <code>update()</code>
		 *
		 *  @param      $currentTime        int     Current time of a tween
		 *  @param      $currentTimeFrame   int     Current time of a tween in frames
		 */
		public function update( $currentTime:int, $currentTimeFrame:int ):Boolean {	
			if( _paused ) return true;
			
			_cTime = _useFrames ? $currentTimeFrame : $currentTime;
			
			if( _started || _cTime >= _timeStart ) {
				if( !_started ) {
					_onStart.dispatch();
					
					for( var i:int=0; i<_properties.length; ++i ) {
						_tProperty = BasicTweenProperties( _properties[ i ]);
						
						if(_tProperty.isSpecialProperty) _specialPropertiesList[_tProperty.id].init(_target, _tProperty.valueComplete);
						else _pv = _target[ _tProperty.id ];

						_tProperty.valueStart = isNaN( _pv ) ? _tProperty.valueComplete : _pv;
						_tProperty.valueChange = _tProperty.valueComplete - _tProperty.valueStart;
					}
					
					_started = true;
				}
				
				if( _cTime >= _timeComplete ) {
					// Tweening time has completed, set to final value
					for( var ii:int=0; ii<_properties.length; ++ii ) {
						_tProperty = BasicTweenProperties( _properties[ ii ]);
						
						if(_tProperty.isSpecialProperty) _specialPropertiesList[_tProperty.id].update(1);
						else _target[ _tProperty.id ] = _tProperty.valueComplete;
					}

					_onUpdate.dispatch();
					_onComplete.dispatch();
					return false;
				}
				
				else {
					// Tweening must continue
					_t = _ease(( _cTime - _timeStart ), 0, 1, _timeDuration );
					for( var iii:int=0; iii<_numProps; ++iii ) {
						_tProperty = BasicTweenProperties( _properties[ iii ]);
						
						if(_tProperty.isSpecialProperty) _specialPropertiesList[_tProperty.id].update(_t);
						else _target[ _tProperty.id ] = _tProperty.valueStart + _t * _tProperty.valueChange;
					}

					_onUpdate.dispatch();
				}
			}

			return true;
		};

		/**
		 *  The <code>pause()</code> method pauses an active tween.
		 */
		public function pause():void {
			if( !_paused ) {
				_paused = true;
				_timePaused = _useFrames ? BasicTween.currentTimeFrame : BasicTween.currentTime; 
			}
		};

		/**
		 * The <code>resume()</code> method resumes a paused tween.
		 */
		public function resume():void {
			if( _paused ) {
				_paused = false;
				
				var timeNow:Number = _useFrames ? BasicTween.currentTimeFrame : BasicTween.currentTime;
				_timeStart += timeNow - _timePaused;
				_timeComplete += timeNow - _timePaused;
			}
		};


		// ===========================================================================================================================
		// PUBLIC STATIC interface ---------------------------------------------------------------------------------------------------

		/**
		 *  The <code>to()</code> method creates a new tween and starts it immediately.
		 *
		 *  @param      $targe      Object      DisplayObject to be tweened.
		 *  @param      $time       Number      Length of tween time.
		 *  @param      $vars       Object      Paramters(x, y, delay, ease, etc.)
		 */
		public static function to( $target:Object, $time:Number, $vars:Object = null ):BasicTween {
			var t:BasicTween = new BasicTween( $target, $time, $vars );
			__tweens.push( t );
			return t;
		};

		/**
		 *  The <code>remove()</code> method removes a tween from an object and the tweening list.
		 *
		 *  @param      $target	    Object      DisplayObject to be removed.
		 *  @param      ...$vars    Arguments	
		 */
		public static function remove( $target:Object, ...$vars ):Boolean {
			var tl:Vector.<BasicTween> = new Vector.<BasicTween>();
			var l:int = __tweens.length;

			for( var i:int=0; i<l; ++i ) {
				if( Boolean( __tweens[ i ]) && __tweens[ i ]._target == $target) {
					if( $vars.length > 0 ) {
						for( var ii:int=0; ii<__tweens[ ii ]._properties.length; ++ii ) {
							if( $vars.indexOf( __tweens[ i ]._properties[ ii ].id ) > -1 ) {
								__tweens[ i ]._properties.splice( ii, 1 );
								ii--;
							}
						}
						if( __tweens[ i ]._properties.length == 0 ) tl.push( __tweens[ i ]);
					} else {
						tl.push( __tweens[ i ]);
					}
				}
			}

			var removedAny:Boolean;
			l = tl.length;

			for( var iii:int=0; iii<l; ++iii ) {
				ii = __tweens.indexOf( tl[iii ]);
				removeTweenByIndex( ii );
				removedAny = true;
			}

			return removedAny;
		};

		/**
		 *  The <code>getTweens()</code> method returns a requested tween.
		 *
		 *  @param      $target     Object      Requested DisplayObject.
		 *  @param      ...$vars    Arguments	
		 */
		public static function getTweens( $target:Object, ...$vars ):Vector.<BasicTween> {
			var tl:Vector.<BasicTween> = new Vector.<BasicTween>();
			var l:int = __tweens.length;
			var exists:Boolean = false;

			for( var i:int=0; i<l; ++i ) {
				if( Boolean( __tweens[ i ]) && __tweens[ i ]._target == $target ) {
					if( $vars.length > 0 ) {
						for( var ii:int=0; ii<__tweens[ i ]._properties.length; ++ii ) {
							if( $vars.indexOf( __tweens[ i ]._properties[ ii ].id ) > -1 ) {
								exists = true;
								break;
							}
						}
						if( exists ) tl.push( __tweens[ i ]);
					} else {
						tl.push( __tweens[ i ]);
					}
				}
			}

			return tl;
		};

		/**
		 *  The <code>pause()</code> method pauses a tween.
		 *
		 *  @param      $target      Object      DisplayObject to be paused.
		 *  @param      ...$vars     Arguments	
		 */
		public static function pause( $target:Object, ...$vars ):Boolean {
			var pausedAny:Boolean = false;
			var ftweens:Vector.<BasicTween> = getTweens.apply( null, [ $target ].concat( $vars ));

			for( var i:int=0; i<ftweens.length; ++i ) {
				if( !ftweens[ i ].paused ) {
					ftweens[ i ].pause();
					pausedAny = true;
				}
			}

			return pausedAny;
		};

		/**
		 * The <code>resume()</code> method resumes a tween.
		 *
		 *  @param      $target     Object      DisplayObject to be resumed.
		 *  @param      ...$vars    Arguments
		 */
		public static function resume( $target:Object, ...$vars ):Boolean {
			var resumedAny:Boolean = false;
			var ftweens:Vector.<BasicTween> = getTweens.apply(null, [$target].concat($vars));

			for( var i:int=0; i<ftweens.length; ++i ) {
				if( ftweens[ i ].paused ) {
					ftweens[ i ].resume();
					resumedAny = true;
				}
			}

			return resumedAny;
		};

		/**
		 * The <code>removeTweenByIndex()</code> method removes a specific tween from the tweening list.
		 *
		 *  @param      $i     Number     Index of the tween to be removed on the tweening list.	
		 */
		public static function removeTweenByIndex( $i:Number ):void {
			__tweens[ $i ] = null;
		};
		
		/**
		 * The <code>registerSpecialProperty()</code> method adds a new special property to the available special property list.
		 *
		 * @param        $id             Name of the "special" property.
		 * @param        $get            Function that gets the value.
		 * @param        $set            Function that sets the value.
		 */
		public static function registerSpecialProperty($id:String, $class:Class):void {
			if(!_init) _initialize();
			_specialPropertiesList[$id] = $class;
			_specialProperties.push($id);
		};


		// ===========================================================================================================================
		// INTERNAL interface --------------------------------------------------------------------------------------------------------

		/**
		 * Starts the engine. 
		 */		
		private static function _initialize():void {
			__eventContainer = new Sprite();
			__eventContainer.addEventListener( Event.ENTER_FRAME, _frameTick );
			
			_specialPropertiesList = new Object();

			currentTimeFrame = 0;
			currentTime = getTimer();
			
			_init = true;
		};


		private function _updateCache():void {
			_timeDuration = _timeComplete - _timeStart;
		}

		/**
		* Updates all existing tweens.
		*/
		private static function _updateTweens():void {
			var l:int = __tweens.length;
			for( var i:int=0; i<l; ++i ) {
				if( !Boolean( __tweens[ i ]) || !BasicTween( __tweens[ i ]).update( currentTime, currentTimeFrame )) {
					__tweens.splice( i, 1 );
					i--;
					l--;
				}
			}
		}
		
		
		// ===========================================================================================================================
		// EVENT interface -----------------------------------------------------------------------------------------------------------

		/**
		* Core engine.
		*/
		private static function _frameTick( $evt:Event ):void
		{
			// Update time
			currentTime = getTimer();

			// Update frame
			currentTimeFrame++;

			// Update all tweens
			_updateTweens();
		}


		// ===========================================================================================================================
		// ACCESSOR interface --------------------------------------------------------------------------------------------------------

		public function get delay():Number { return ( _timeStart - _timeCreated ) / ( _useFrames ? 1 : 1000 ); }
		public function set delay( $val:Number ): void {
			_timeStart = _timeCreated + ( $val * ( _useFrames ? 1 : 1000 ));
			_timeComplete = _timeStart + _timeDuration;
			//updateCache();
		}

		public function get time():Number { return ( _timeComplete - _timeStart ) / ( _useFrames ? 1 : 1000 ); }
		public function set time( $val:Number ): void {
			_timeComplete = _timeStart + ( $val * ( _useFrames ? 1 : 1000 ));
			_updateCache();
		}

		public function get paused():Boolean { return _paused; }

		public function get useFrames():Boolean { return _useFrames; }
		public function set useFrames( $val:Boolean ):void {
			var tDelay:Number = delay;
			var tTime:Number = time;
			_useFrames = $val;
			_timeStart = _useFrames ? currentTimeFrame : currentTime;
			delay = tDelay;
			time = tTime;
		}

		public function get target():Object { return _target; }
		public function set target( target:Object ):void { _target = target; }
	}
}
