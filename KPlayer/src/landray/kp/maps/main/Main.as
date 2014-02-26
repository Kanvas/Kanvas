package landray.kp.maps.main
{
	import flash.geom.Rectangle;
	
	import landray.kp.maps.main.elements.BaseElement;
	import landray.kp.maps.main.elements.Label;
	import landray.kp.maps.main.util.MainUtil;
	import landray.kp.utils.CoreUtil;
	import landray.kp.view.Graph;
	
	import model.vo.ElementVO;
	
	public final class Main extends Graph
	{
		public function Main()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			elements = new Vector.<BaseElement>;
		}
		
		override public function render(scale:Number = 1):void
		{
			if (viewer.stage)
			{
				var count:int = 0;
				for each (var element:BaseElement in elements)
				{
					var bound:Rectangle = element.getBounds(viewer.stage);
					element.visible = ! (bound.left > viewer.stage.stageWidth || bound.right < 0 || bound.bottom < 0 || bound.top > viewer.stage.stageHeight);
					if (element.visible && element is Label)
					{
						count ++;
						element.render(scale);
					}
				}
				//trace("label rendered:", count);
			}
			
		}
		
		override public function set dataProvider(value:XML):void
		{
			//clear
			for each (var element:BaseElement in elements)
				viewer.canvas.removeChild(element);
			elements.length = 0;
			
			//create vos and elements
			var list:XMLList = value.children();
			for each (var xml:XML in list) 
			{
				var vo:ElementVO = MainUtil.getElementVO(String(xml.@type));
				CoreUtil.mapping(xml, vo);
				
				try
				{
					//这里他妈的有特殊字符的话就导致崩溃了
					element = MainUtil.getElementUI(vo);
					if (element)
					{
						CoreUtil.applyStyle(element.vo);
						CoreUtil.mapping(xml, vo);
						element.render();
						viewer.canvas.addChild(element);
						elements.push(element);
					}
					
				}
				catch(error:Error) 
				{
					trace(error.getStackTrace());
				}
				
			}
		}
		
		private var elements:Vector.<BaseElement>;
		
	}
}