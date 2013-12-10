package view.interact
{
	
	import commands.Command;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	
	import util.CoreUtil;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.element.shapes.LineElement;
	import view.interact.autoGroup.IAutoGroupElement;
	import view.interact.multiSelect.TemGroupElement;

	public final class ElementAutoLayerController
	{
		public function ElementAutoLayerController($coreMdt:CoreMediator)
		{
			coreMdt = $coreMdt;
		}
		
		/**
		 * 自动将元素排列至合适的层级并将元素以前的层级返回，如果为-1表示元素已在最合适的位置，无需排列
		 */
		public function autoLayer(current:ElementBase, shapeFlag:Boolean = false):Vector.<int>
		{
			var layer:Vector.<int>;
			_indexChangeElement = null;
			if (enabled)
			{
				for each (var element:ElementBase in elements)
				{
					if (checkAutoLayerAvailable(current, element, shapeFlag))
					{
						if (_indexChangeElement == null)
							_indexChangeElement = new Vector.<ElementBase>;
						_indexChangeElement.push(element);
						if (layer == null)
							layer = new Vector.<int>;
						layer.push(element.index);
					}
				}
				if (_indexChangeElement)
				{
					//当前元素放入层级比较队列
					_indexChangeElement.push(current);
					layer.push(current.index);
					var length:int = layer.length;
					//获得一个重新比较后的顺序数组order
					var order:Vector.<int> = getOrderBySize(_indexChangeElement);
					
					/*
					for (var i:int = 0; i < length; i++)
					{
						trace(_indexChangeElement[i], layer[i], order[i]);
					}
					*/
					//重新排列元素
					swapElements(indexChangeElement, order);
				}
			}
			return layer;
		}
		
		public function swapElements(items:Vector.<ElementBase>, order:Vector.<int>):void
		{
			var layer:Vector.<int> = new Vector.<int>;
			var length:int = items.length;
			for (var i:int = 0; i < length; i++)
			{
				layer[i] = items[i].index;
			}
			
			for (i = 0; i < length - 1; i++)
			{
				if (order[i] == layer[i]) continue;
				for (var j:int = i + 1; j<length; j++)
				{
					if (order[i] == layer[j])
					{
						coreMdt.canvas.swapChildrenAt(layer[i], layer[j]);
						//元素位置已经变换，需要刷新layer
						for (var k:int = 0; k < length; k++)
							layer[k] = items[k].index;
						break;
					}
				}
			}
		}
		
		public function get indexChangeElement():Vector.<ElementBase>
		{
			return _indexChangeElement;
		}
		private var _indexChangeElement:Vector.<ElementBase>;
		
		
		
		private function get elements():Vector.<ElementBase>
		{
			return CoreFacade.coreProxy.elements;
		}
		
		private function getOrderBySize(items:Vector.<ElementBase>):Vector.<int>
		{
			var itemsBefore:Vector.<ElementBase> = items;
			var itemsAfter :Vector.<ElementBase> = items.concat();
			var layerBefore:Vector.<int> = new Vector.<int>;
			for each (var item:ElementBase in itemsBefore)
			{
				layerBefore.push(item.index);
			}
			
			var layerAfter:Vector.<int> = layerBefore.concat();
			var length:int = layerBefore.length;
			for (var i:int = 0; i < length - 1; i++)
			{
				for (var j:int = i + 1; j < length; j++)
				{
					var current:ElementBase = itemsAfter[i];
					var element:ElementBase = itemsAfter[j];
					var currentW:Number = (current is LineElement) ? current.scaledWidth * .5 : current.scaledHeight;
					var elementW:Number = (element is LineElement) ? element.scaledWidth * .5 : element.scaledWidth;
					var currentH:Number = current.scaledHeight;
					var elementH:Number = element.scaledHeight;
					var currentL:int = layerBefore[i];
					var elementL:int = layerBefore[j];
					
					if ((elementW < currentW && elementH < currentH && elementL < currentL) ||
						(elementW > currentW && elementH > currentH && currentL < elementL))
					{
						var temp:ElementBase = itemsAfter[i];
						itemsAfter[i] = itemsAfter[j];
						itemsAfter[j] = temp;
					}
				}
			}
			
			for (i = 0; i < length; i++)
			{
				layerAfter[i] = layerBefore[itemsAfter.indexOf(itemsBefore[i])];
			}
			
			return layerAfter;
		}
		
		private function checkAutoLayerAvailable(current:ElementBase, element:ElementBase, flag:Boolean):Boolean
		{
			var result:Boolean = false;
			if (current != element)
			{
				if (! (current is TemGroupElement) && ! (current is GroupElement) && ! current.grouped && 
					! (element is TemGroupElement) && ! (element is GroupElement) && ! element.grouped)
				{
					var inGroup:Boolean = (! CoreUtil.inAutoGroup(current)) && (! CoreUtil.inAutoGroup(element) || flag);
					result = inGroup && ifInElement(element, current);
				}
			}
			return result;
		}
		
		private function ifInElement(element:ElementBase, hitElement:ElementBase):Boolean
		{
			var erect:Rectangle = CoreUtil.getRectForStage(element);
			var hrect:Rectangle = CoreUtil.getRectForStage(hitElement);
			
			return ((erect.left > hrect.left && erect.right < hrect.right && erect.top > hrect.top && erect.bottom < hrect.bottom) || 
				(erect.left < hrect.left && erect.right > hrect.right && erect.top < hrect.top && erect.bottom > hrect.bottom));
		}
		
		public var enabled:Boolean = true;
		
		private var coreMdt:CoreMediator;
	}
}