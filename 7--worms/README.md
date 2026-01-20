Worms

Learned

* Polygon2D + Geometry2D. Getting started working with these was tricky!
  * Clockwise:
    * I initially didn't realize polygon points should be clockwise in order for the inside portion to be considered its shape. I had one of my polygons defined counterclockwise which made the Geometry clip method not work properly when trying to clip it with a clockwise polygon.
  * Polygon clipping result:
    * A Polygon2D's `polygon` property is a `PackedVector2Array` (an array of Vector2Ds).
    * The result of the clip function is `Array[PackedVector2Array]` (because it's possible to clip a polygon into multiple distinct polygons)
    * Key insight was I needed to take the first element of the array (if just one resulting polygon), or if I want to render the multiple resulting polygons, to create a new Polygon2D node for each one.
  * Polygon2D `polygon` vs `polygons` property
    * `polygons` is simply an array of integers that index into the `polygon` property. So setting `polygons` as the result of the clip function does not work.