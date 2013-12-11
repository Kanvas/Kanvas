package view.pagePanel
{
	import com.kvs.ui.FiUI;
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.utils.Map;
	import com.kvs.utils.PerformaceTest;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.elements.BreakElement;
	
	/**
	 * 负责页面创建命令发出，页面列表显示，页面顺序调换命令发出
	 */	
	public class PagePanel extends FiUI
	{
		public function PagePanel(kvs:Kanvas)
		{
			super();
			
			this.core = kvs;
			this.w = 150;
		}
		
		
		
		
		//------------------------------------------------
		//
		//
		//
		// 
		//
		//
		//
		//------------------------------------------------
		
		
		
		/**
		 * 告知core去创建一个页面
		 */		
		private function addPage(evt:MouseEvent):void
		{
			//模拟代码
			var page:Object = new Object;
			pageAdded(page);
			
			page.index = pagesCtn.numChildren - 1;
			layoutPages();
		}
		
		/**
		 * core页面创建成功反馈
		 */		
		public function pageAdded(pageVO:Object):void
		{
			var pageUI:PageUI = new PageUI(pageVO);
			
			pageUI.w = scrollProxy.viewWidth - gutter * 2;
			pageUI.h = 100;
			
			pagesCtn.addChild(pageUI);
			pages.push(pageUI);
		}
		
		/**
		 */		
		private var pages:Vector.<Object> = new Vector.<Object>;
		
		/**
		 * 从core中删除了某个页面后
		 */		
		public function pagedDeleted(pageVO:Object):void
		{
			var pageUI:PageUI = findPageUIByVO(pageVO);
			
			pages.splice(pages.indexOf(pageUI), 1);
			pagesCtn.removeChild(pageUI);
		}
		
		/**
		 * 从页面列表中选择了某个页面
		 */		
		public function pageSelected(pageVO:Object):void
		{
			
		}
		
		/**
		 * 把某个页面移动到新位置
		 */		
		public function switchPage(page:Object, newIndex:uint):void
		{
			
		}
		
		/**
		 * 页面初始化，数据导入时用到
		 */		
		public function initPages(pages:Vector.<Object>):void
		{
			var pageVO:Object;
			for each (pageVO in pages)
			{
				pageAdded(pageVO);
			}
		}
		
		/**
		 * 根据页面的序号重新排列所有页面，并更新序号显示
		 */		
		private function layoutPages():void
		{
			var pageUI:PageUI;
			for each (pageUI in pages)
			{
				pageUI.x = gutter;
				pageUI.y = gutter + pageUI.pageVO.index * (pageUI.h + gutter);
				
				pageUI.updataLabel();
			}
			
			scrollProxy.update();
		}
		
		/**
		 */		
		private function findPageUIByVO(pageVO:Object):PageUI
		{
			var pageUI:PageUI;
			for each(pageUI in pages)
			{
				if (pageUI.pageVO == pageVO)
					break;
			}
			
			return pageUI;
		}
		
		
		
		
		
		
		
		
		//------------------------------------------------
		//
		//
		//
		// 
		//
		//
		//
		//------------------------------------------------
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			XMLVOMapper.fuck(bgStyleXML, bgStyle);
			
			addBtn.w = w - gutter;
			addBtn.h = 100;
			addBtn.text = "添加页面";
			this.addChild(addBtn);
			addBtn.addEventListener(MouseEvent.CLICK, addPage);
			
			scrollProxy = new PagesScrollProxy(this);
			addChild(pagesCtn);
			updateLayout();
		}
		
		/**
		 */		
		public function updateLayout():void
		{
			render();
			
			addBtn.x = (w - addBtn.w) / 2;
			addBtn.y = h - addBtn.h - gutter;
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, scrollProxy.viewWidth, scrollProxy.viewHeight);
			this.graphics.endFill();
			
			this.graphics.moveTo(scrollProxy.viewWidth, scrollProxy.viewHeight);
			this.graphics.lineTo(w, scrollProxy.viewHeight);
			
			scrollProxy.updateMask();
			scrollProxy.update();
		}
		
		/**
		 * 
		 */		
		public function render():void
		{
			bgStyle.width = w;
			bgStyle.height = h;
			
			PerformaceTest.start();
			StyleManager.drawRect(this, bgStyle);
			PerformaceTest.end();
		}
		
		/**
		 */		
		private var scrollProxy:PagesScrollProxy;
		
		/**
		 * 防止页面的容器 
		 */		
		internal var pagesCtn:Sprite = new Sprite;
		
		/**
		 */		
		internal var gutter:uint = 10;
		
		/**
		 */		
	    internal var addBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		private var bgStyle:Style = new Style;
		
		/**
		 */		
		private var core:Kanvas;
		
		/**
		 */		
		public var bgStyleXML:XML;
	}
}