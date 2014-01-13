package view.ui
{
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
		function updateXToCanvas():void
		function updateYToCanvas():void
		function updateLayoutToCanvas():void
	}
}