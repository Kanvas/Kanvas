package view.elementSelector.scaleRollControl
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import view.elementSelector.ControlPointBase;
	
	public final class FitPoint extends ControlPointBase
	{
		public function FitPoint()
		{
			super();
		}
		
		/**
		 */			
		override public function render():void
		{
			this.graphics.clear();
			
			StyleManager.setShapeStyle(currState, graphics);
			StyleManager.drawCircle(this, currState);
		}
	}
}