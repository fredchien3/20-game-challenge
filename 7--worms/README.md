Beans

A tactical game inspired by Worms

Play it! https://fredchien3.itch.io/worms

<img width="1276" height="706" alt="Screenshot 2026-03-24 101116" src="https://github.com/user-attachments/assets/37e44a8b-f178-4968-851e-91ff47bccecb" />
<img width="1268" height="706" alt="Screenshot 2026-03-24 100916" src="https://github.com/user-attachments/assets/c9e3ab36-ed70-48bd-bfb0-490f53db290a" />
<img width="1260" height="710" alt="Screenshot 2026-03-24 100837" src="https://github.com/user-attachments/assets/ad39f09b-844b-454e-a218-206954017d38" />


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
