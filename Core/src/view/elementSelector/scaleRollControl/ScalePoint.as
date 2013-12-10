package view.elementSelector.scaleRollControl
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import view.elementSelector.ControlPointBase;

	/**
	 */	
	public class ScalePoint extends ControlPointBase
	{
		public function ScalePoint()
		{
			super();
		}
		
		/**
		 */			
		override public function render():void
		{
			this.graphics.clear();
			
			StyleManager.setShapeStyle(currState, graphics);
			StyleManager.drawRect(this, currState);
		}
	}
}