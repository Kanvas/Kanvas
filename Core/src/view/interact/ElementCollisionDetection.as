package view.interact
{
	//import com.kvs.utils.HitTest;
	
	import com.kvs.utils.RectangleUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import util.LayoutUtil;
	
	import view.element.ElementBase;
	import view.element.shapes.LineElement;
	import view.element.text.TextEditField;
	import view.interact.autoGroup.AutoGroupController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	/**
	 * 碰撞检测，辅助智能组合，画布缩放过程中的的图形交互失效，隐藏等
	 */	
	public class ElementCollisionDetection
	{
		/**
		 * 控制智能群组的移动，缩放和大图形是否可以被点击
		 */		
		public function ElementCollisionDetection(mdt:CoreMediator, elements:Vector.<ElementBase>, hitObject:DisplayObject)
		{
			this.coreMdt = mdt;
			this.elements = elements;
			this.hitObject = hitObject;
		}
		
		/**
		 */		
		private var coreMdt:CoreMediator;
		
		/**
		 */		
		private var hitObject:DisplayObject;
		
		/**
		 * 检测智能组合；
		 * 
		 * ifAll 是否包含非智能组合元素，多选时用到
		 */		
		public function checkAutoGroup(curElement:ElementBase, autoGroupControl:AutoGroupController, ifAll:Boolean = false):void
		{
			if (autoGroupControl.enabled == false) return;
			//当前选择是文本的话不进行智能组合
			if (curElement is IAutoGroupElement && !(curElement is TextEditField))
			{
				//中心点碰撞
				var ifHit:Boolean;
				
				for each (var element:ElementBase in elements)
				{
					//确保元素非组合内容，被碰撞，并且是可以智能组合的元素
					if (element.canAutoGrouped && (element is IAutoGroupElement || ifAll) && element != curElement)
					{
						//要确保被检测元件的中心点与参考元件实际性碰撞，而非仅与其轮廓矩形相碰撞
						ifHit = ifHitElement(element, curElement.shape);
						
						//碰撞
						if (ifHit)
						{
							if (element is LineElement)
							{
								if (element.scaledWidth / 2 < curElement.scaledWidth && element.scaledHeight < curElement.scaledHeight)
									autoGroupControl.pushElement(element as IAutoGroupElement);
							}
							else if (element.scaledWidth < curElement.scaledWidth && element.scaledHeight < curElement.scaledHeight)
							{
								autoGroupControl.pushElement(element as IAutoGroupElement);
							}
						}
					}
				}
			}
		}
		
		/**
		 * 是否图形与元件碰撞，这里的碰撞是指元件的中心与图形碰撞
		 */		
		public function ifHitElement(element:ElementBase, hitElement:DisplayObject):Boolean
		{
			var point:Point = LayoutUtil.elementPointToStagePoint(element.vo.x, element.vo.y, coreMdt.canvas);
			return hitElement.hitTestPoint(point.x, point.y, true);
		}
		
		/**
		 * 
		 * 显示区域外的元件会被隐藏
		 * 
		 * 显示区域内的元件，尺寸超出区域大小时会被禁止交互;
		 * 
		 * 显示区域 内的元件，尺寸过小时也会被禁止交互, 并且隐藏
		 */		
		public function updateAfterZoomMove():void
		{
			var minLineInteractSizeSquare:Number = minInteractSize * minInteractSize * .25;
			for each (var element:ElementBase in elements)
			{
				var bound:Rectangle = LayoutUtil.getItemRect (coreMdt.canvas, element);
				var stage:Rectangle = LayoutUtil.getStageRect(coreMdt.canvas);
				
				if (RectangleUtil.rectOverlapping(bound, stage))
				{
					element.visible = ! (bound.width < minVisibleSize && bound.height < minVisibleSize);
					var w:Number = stage.width  - 100;
					var h:Number = stage.height - 100;
					if (element is LineElement)
					{
						var size:Number = (bound.width * bound.width + bound.height * bound.height) >> 1;
						if (size > w || size < minLineInteractSizeSquare)
							element.disable();//过小禁止交互
						else
							element.enable();
					}
					else if (element is TextEditField)
					{
						if (bound.width > w || bound.height > h || bound.width < 15 || bound.height < 5)
							element.disable();
						else
							element.enable();
					}
					else if (bound.width > w || bound.width < minInteractSize || bound.height > h || bound.height < minInteractSize)
					{
						element.disable();
					}
					else
					{
						element.enable();
					}
				}
				else
				{
					element.visible = false;
				}
			}
		}
		
		/**
		 */		
		private var minInteractSize:uint = 15;
		
		/**
		 */		
		private var minVisibleSize:uint = 5;
		
		/**
		 */		
		private var elements:Vector.<ElementBase>;
		
	}
}