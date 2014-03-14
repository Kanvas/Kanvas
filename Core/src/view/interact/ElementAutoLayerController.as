package view.interact
{
	
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	
	import util.LayoutUtil;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.element.shapes.LineElement;
	import view.interact.multiSelect.TemGroupElement;

	public final class ElementAutoLayerController
	{
		public function ElementAutoLayerController($coreMdt:CoreMediator)
		{
			coreMdt = $coreMdt;
		}
		
		/**
		 * 自动将元素排列至合适的层级并将元素以前的层级数组返回
		 */
		public function autoLayer(current:ElementBase):Vector.<int>
		{
			var layer:Vector.<int>;
			_indexChangeElement = null;
			if (enabled)
			{
				for each (var element:ElementBase in elements)
				{
					if (checkAutoLayerAvailable(current, element))
					{
						if (_indexChangeElement == null)
							_indexChangeElement = new Vector.<ElementBase>;
						_indexChangeElement.push(element);
					}
				}
				if (_indexChangeElement)
				{
					//当前元素放入层级比较队列
					_indexChangeElement.push(current);
					_indexChangeElement.sort(sortOnElementIndex);
					/*for each (element in _indexChangeElement)
						trace(element, element.index);*/
					layer = new Vector.<int>;
					for each (element in _indexChangeElement)
						layer.push(element.index);
					
					var length:int = layer.length;
					//获得一个重新比较后的顺序数组order
					var order:Vector.<int> = getOrderBySize(_indexChangeElement);
					//trace(order);
					//重新排列元素
					swapElements(_indexChangeElement, order);
				}
			}
			return layer;
		}
		
		/**
		 * 对element集合根据传入的order数组排列层级。 
		 * @param items
		 * @param order
		 * 
		 */
		public function swapElements(items:Vector.<ElementBase>, order:Vector.<int>):void
		{
			var layer:Vector.<int> = new Vector.<int>;
			var length:int = items.length;
			for (var i:int = 0; i < length; i++)
				layer[i] = items[i].index;
			
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
		
		/**
		 * 根据传入的element集合按照尺寸重新排列层级，并返回一个层级数组。
		 * 
		 */
		private function getOrderBySize(items:Vector.<ElementBase>):Vector.<int>
		{
			var itemsBefore:Vector.<ElementBase> = items;
			var itemsAfter :Vector.<ElementBase> = items.concat();
			var layerBefore:Vector.<int> = new Vector.<int>;
			var layerAfter :Vector.<int> = new Vector.<int>;
			
			for each (var item:ElementBase in itemsBefore)
				layerBefore.push(item.index);

			itemsAfter.sort(sortOnElementLayer);
			
			var length:int = itemsAfter.length;
			for (var i:int = 0; i < length; i++)
				layerAfter[i] = layerBefore[itemsAfter.indexOf(itemsBefore[i])];

			return layerAfter;
		}
		
		private function sortOnElementIndex(a:ElementBase, b:ElementBase):int
		{
			if (a.index < b.index)
				return -1;
			else if (a.index == b.index)
				return 0;
			else 
				return 1;
		}
		
		private function sortOnElementLayer(a:ElementBase, b:ElementBase):int
		{
			var aw:Number = (a is LineElement) ? a.scaledWidth * .5 : a.scaledWidth;
			var bw:Number = (b is LineElement) ? b.scaledWidth * .5 : b.scaledWidth;
			var ah:Number = a.scaledHeight;
			var bh:Number = b.scaledHeight;
			if (ifInElement(a, b))
			{
				if (aw > bw && ah > bh)
					return -1;
				else if (aw < bw && ah < bh)
					return 1;
				else 
					return 0;
			}
			else
			{
				return 0;
			}
		}
		
		private function checkAutoLayerAvailable(current:ElementBase, element:ElementBase):Boolean
		{
			var result:Boolean = false;
			if (current && current != element)
			{
				if (! (current is TemGroupElement) && ! (current is GroupElement) && ! current.grouped && 
					! (element is TemGroupElement) && ! (element is GroupElement) && ! element.grouped)
				{
					result = ifInElement(element, current);
				}
			}
			return result;
		}
		
		private function ifInElement(element:ElementBase, hitElement:ElementBase):Boolean
		{
			var erect:Rectangle = LayoutUtil.getItemRect(coreMdt.canvas, element);
			var hrect:Rectangle = LayoutUtil.getItemRect(coreMdt.canvas, hitElement);
			
			return ((erect.left > hrect.left && erect.right < hrect.right && erect.top > hrect.top && erect.bottom < hrect.bottom) || 
				(erect.left < hrect.left && erect.right > hrect.right && erect.top < hrect.top && erect.bottom > hrect.bottom));
		}
		
		public var enabled:Boolean = true;
		
		private var coreMdt:CoreMediator;
	}
}