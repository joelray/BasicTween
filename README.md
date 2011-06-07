Basic Tween
===========

### ActionScript 3 Tween Engine ###

Created by [Joel Ray](https://github.com/joelray).


### Change Log ###

2011-06-07 - **r6**

* Changed all push() calls to vector[vector.length] = value, for speed enhancements.
* Internal property, **_keywords**, is now a String Vector.
* Removed old properties class.
* Optimizations ++.

2011-04-11 - **r5**

* Fixed a bug that wouldn't allow more than one instance of a special property.
* Renamed _BasicTweenProperties_ to _BasicTweenProperty_ as it only contains details of a single prop.
* Optimizations ++.


2011-04-10 - **r4**

* Added some internal comments.
* Deleted unused variables.
* Quick code clean-up.


2011-04-10 - **r3**

* Added the ability to tween special properties such as blur, brightness, color, alpha/visibility (fade), frames, and volume.


2011-03-28 - **r2**

* Created a filter to ignore any non-object properties, such as 'ease', etc.


2010 05 01 - **r1**

* Initial build


### TODO ###

* The source files still need a little tending to as their not the prettiest to look at.