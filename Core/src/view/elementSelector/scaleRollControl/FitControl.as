package view.elementSelector.scaleRollControl
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	
	import flash.display.Sprite;
	
	import view.elementSelector.ElementSelector;
	
	public final class FitControl implements IClickMove
	{
		public function FitControl(holder:ElementSelector, ui:Sprite)
		{
			this.selector = holder;
			
			moveControl = new ClickMoveControl(this, ui);
		}
		
		public function clicked():void
		{
			/////
		}
		
		public function moveOff(xOff:Number, yOff:Number):void
		{
		}
		
		public function startMove():void
		{
		}
		
		public function stopMove():void
		{
		}
		
		private var selector:ElementSelector;
		
		/**
		 */		
		private var moveControl:ClickMoveControl;
	}
}