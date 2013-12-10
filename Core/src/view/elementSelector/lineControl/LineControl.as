package view.elementSelector.lineControl
{
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.IPointControl;
	
	/**
	 * 线条的控制器，托拉拽控制点后线条重新绘制
	 */	
	public class LineControl extends Sprite implements IPointControl
	{
		public function LineControl(selector:ElementSelector)
		{
			super();
			
			this.selector = selector;
			
			startControl = new StartPointControl(selector, startPoint);
			startPoint.styleConfig = pointStyle;
			addChild(startPoint);
			
			endControl = new EndPointControl(selector, endPoint);
			endPoint.styleConfig = pointStyle;
			addChild(endPoint);
		}
		
		/**
		 */		
		private var startControl:StartEndControlBase;
		
		/**
		 */		
		private var startPoint:ControlPointBase = new ControlPointBase;
		
		/**
		 */		
		private var endPoint:ControlPointBase = new ControlPointBase;
		
		/**
		 */		
		private var endControl:EndPointControl;
		
		/**
		 */		
		public function layout(style:Style):void
		{
			if (visible)
			{
				startPoint.x = 0//- selector.elementWidthForStage / 2;
				startPoint.y = 0;
				
				endPoint.x = selector.elementWidthForStage / 2;
				endPoint.y = 0;
			}
		}
		
		/**
		 */			
		private var pointStyle:XML = <states>
											<normal tx='-5' ty='-5' width='10' height='10' radius='5'>
												<border thickness='1' alpha='1' color='#373737'/>
												<fill color='#6a6a6a, #585858' alpha='0.7, 0.7' angle='90'/>
											</normal>
											<hover tx='-6' ty='-6' width='12' height='12' radius='6'>
												<border thickness='1' alpha='1' color='#373737'/>
												<fill color='#6a6a6a, #585858' alpha='1, 1' angle='90'/>
											</hover>
											<down tx='-6' ty='-6' width='12' height='12' radius='6'>
												<border color='#6a6a6a' thickness='1'/>
												<fill color='#6a6a6a' alpha='0.7'/>
											</down>
										</states>
		
		/**
		 */		
		private var selector:ElementSelector;
	}
}