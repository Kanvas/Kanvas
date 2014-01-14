package view.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import landray.kp.ui.Loading;
	
	/**
	 */	
	public class Canvas extends Sprite
	{
		public function Canvas($mainUI:MainUIBase)
		{
			super();
			
			this.mainUI = $mainUI;
			
			items = new Vector.<ICanvasLayout>;
			indexs = new Dictionary;
			
			addChild(interactorBG);
			//interactorBG.addChild(bgImgContainer = new Sprite);
		}
		
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			if (child is ICanvasLayout)
			{
				var item:ICanvasLayout = ICanvasLayout(child);
				item.updateView();
				items.push(item);
				indexs[item] = items.length;
			}
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt(child, index);
			if (child is ICanvasLayout)
			{
				var item:ICanvasLayout = ICanvasLayout(child);
				item.updateView();
				items.push(item);
				indexs[item] = items.length;
			}
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			super.removeChild(child);
			if (child is ICanvasLayout)
			{
				var item:ICanvasLayout = ICanvasLayout(child);
				item.updateView();
				items.splice(indexs[item], 1);
				delete indexs[item];
			}
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt(index);
			if (child is ICanvasLayout)
			{
				var item:ICanvasLayout = ICanvasLayout(child);
				item.updateView();
				items.splice(indexs[item], 1);
				delete indexs[item];
			}
			return child;
		}
		
		override public function removeChildren(beginIndex:int=0, endIndex:int=int.MAX_VALUE):void
		{
			endIndex = Math.min(numChildren, endIndex);
			for (var i:int = beginIndex; i < endIndex; i++)
			{
				var child:DisplayObject = getChildAt(i);
				if (child is ICanvasLayout)
				{
					var item:ICanvasLayout = ICanvasLayout(child);
					items.splice(indexs[item], 1);
					delete indexs[item];
				}
			}
			super.removeChildren(beginIndex, endIndex);
		}
		
		/**
		 */		
		private var mainUI:MainUIBase;
		
		/**
		 * 是否含有元件
		 */		
		public function get ifHasElements():Boolean
		{
			return (numChildren > 1);
		}
		
		/**
		 */		
		public function drawBG(rect:Rectangle):void
		{
			interactorBG.graphics.clear();
			interactorBG.graphics.beginFill(0x666666, 0);
			interactorBG.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			interactorBG.graphics.endFill();
		}
		
		
		
		/**
		 * 画布自动缩放时需要清空背景，保证尺寸位置计算的准确性
		 */		
		public function clearBG():void
		{
			interactorBG.graphics.clear();
		}
		
		/*private function drawImageBG(rect:Rectangle):void
		{
		bgImgContainer.graphics.clear();
		bgImgContainer.graphics.beginFill(0x666666, 1);
		bgImgContainer.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		bgImgContainer.graphics.endFill();
		}*/
		
		/*public function showLoading(rect:Rectangle):void
		{
			drawImageBG(rect);
			
			if (loading == null)
			{
				loading = new Loading;
				interactorBG.addChild(loading);
			}
		}
		
		public function hideLoading():void
		{
			bgImgContainer.graphics.clear();
			
			if (loading)
			{
				if (interactorBG.contains(loading))
					interactorBG.removeChild(loading);
				loading.stop();
				loading = null;
			}
		}*/
		
		override public function get scaleX():Number
		{
			return __scaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			if (__scaleX!= value) 
			{
				__scaleX = value;
				for each (var item:ICanvasLayout in items)
					item.updateView();
			}
		}
		
		private var __scaleX:Number = 1;
		
		override public function get scaleY():Number
		{
			return __scaleY;
		}
		
		override public function set scaleY(value:Number):void
		{
			if (__scaleY!= value) 
			{
				__scaleY = value;
				for each (var item:ICanvasLayout in items)
					item.updateView();
			}
		}
		
		private var __scaleY:Number = 1;
		
		override public function get rotation():Number
		{
			return __rotation;
		}
		
		override public function set rotation(value:Number):void
		{
			if (__rotation!= value) 
			{
				__rotation = value;
				for each (var item:ICanvasLayout in items)
					item.updateView();
			}
		}
		
		private var __rotation:Number = 0;
		
		override public function get x():Number
		{
			return __x;
		}
		
		override public function set x(value:Number):void
		{
			if (__x!= value) 
			{
				__x = value;
				for each (var item:ICanvasLayout in items)
					item.updateView();
			}
		}
		
		private var __x:Number = 0;
		
		override public function get y():Number
		{
			return __y;
		}
		
		override public function set y(value:Number):void
		{
			if (__y!= value) 
			{
				__y = value;
				for each (var item:ICanvasLayout in items)
					item.updateView();
			}
		}
		
		private var __y:Number = 0;
		
		/**
		 */		
		public var interactorBG:Sprite = new Sprite;
		
		private var items:Vector.<ICanvasLayout>;
		private var indexs:Dictionary;
	}
}