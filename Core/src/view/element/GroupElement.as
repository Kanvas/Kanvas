package view.element
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.CoreFacade;
	import model.vo.GroupVO;
	
	import view.element.state.ElementSelected;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	/**
	 * 组合
	 */	
	public class GroupElement extends ElementBase implements IAutoGroupElement
	{
		public function GroupElement(vo:GroupVO)
		{
			super(vo);
		}
		
		/**
		 */		
		override public function exportData():XML
		{
			xmlData = <group/>;
			xmlData = super.exportData();
			
			var element:ElementBase;
			for each(element in childElements)
				xmlData.appendChild(<{element.vo.type} id={element.vo.id}/>);
				
			return xmlData;
		}
		
		/**
		 */		
		override public function copy():void
		{
			this.dispatchEvent(new ElementEvent(ElementEvent.COPY_GROUP, this));
		}
		
		/**
		 */		
		override public function paste():void
		{
			this.dispatchEvent(new ElementEvent(ElementEvent.PAST_GROUP, this));
		}
		
		/**
		 */		
		override public function getChilds(group:Vector.<ElementBase>):Vector.<ElementBase>
		{
			var elements:ElementBase;
			for each (elements in childElements)
				group = elements.getChilds(group);
			
			group.push(this);
			
			return group;
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var goupVO:GroupVO = new GroupVO;
			var group:GroupElement = new GroupElement(cloneVO(goupVO) as GroupVO);
			
			var element:ElementBase;
			var newElement:ElementBase;
			for each (element in childElements)
			{
				newElement = element.clone();
				newElement.toGroupState();
				group.childElements.push(newElement);
			}
			
			return group;
		}
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			// 中心点为注册点
			vo.style.tx = - vo.width / 2;
			vo.style.ty = - vo.height / 2;
			
			vo.style.width = vo.width;
			vo.style.height = vo.height;
			
			graphics.clear();
			if (currentState is ElementSelected)
			{
				StyleManager.drawRect(this, vo.style, vo);
			}
			else
			{
				this.graphics.beginFill(0, 0);
				this.graphics.drawRect(vo.style.tx, vo.style.ty, vo.style.width, vo.style.height);
				this.graphics.endFill();
			}
		}
		
		/**
		 * 选择状态下才会呈现
		 */		
		override public function toSelectedState():void
		{
			graphics.clear();
			StyleManager.drawRect(this, vo.style, vo);
			
			super.toSelectedState();
		}
		
		/**
		 */		
		override public function toUnSelectedState():void
		{
			graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(vo.style.tx, vo.style.ty, vo.style.width, vo.style.height);
			this.graphics.endFill();
			
			super.toUnSelectedState();
		}
		
		/**
		 */		
		override public function toMultiSelectedState():void
		{
			super.toMultiSelectedState();
		}
		
		/**
		 */		
		override public function toGroupState():void
		{
			super.toGroupState();
		}
				
		/**
		 */		
		override public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.group);
		}
		
		/**
		 */		
		private var _childElements:Vector.<ElementBase> = new Vector.<ElementBase>;

		/**
		 */
		public function get childElements():Vector.<ElementBase>
		{
			return _childElements;
		}

		/**
		 * @private
		 */
		public function set childElements(value:Vector.<ElementBase>):void
		{
			_childElements = value;
		}

	}
}