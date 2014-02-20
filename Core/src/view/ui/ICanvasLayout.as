package view.ui
{
	import flash.geom.Point;

	public interface ICanvasLayout
	{
		function get x():Number
		function set x(value:Number):void
		function get y():Number
		function set y(value:Number):void
		function get scaleX():Number
		function set scaleX(value:Number):void
		function get scaleY():Number
		function set scaleY(value:Number):void
		function get measureX():Number
		function set measureX(value:Number):void
		function get measureY():Number
		function set measureY(value:Number):void
		function get measureScaleX():Number
		function set measureScaleX(value:Number):void
		function get measureScaleY():Number
		function set measureScaleY(value:Number):void
			
		function get scaledWidth ():Number
		function get scaledHeight():Number
		
		function get topLeft     ():Point
		function get topCenter   ():Point
		function get topRight    ():Point
		function get middleLeft  ():Point
		function get middleCenter():Point
		function get middleRight ():Point
		function get bottomLeft  ():Point
		function get bottomCenter():Point
		function get bottomRight ():Point
			
		function get left  ():Number
		function get right ():Number
		function get top   ():Number
		function get bottom():Number
			
		function get visible():Boolean
		function set visible(value:Boolean):void
		
		function updateView():void
	}
}