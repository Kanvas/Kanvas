package view.pagePanel
{
	import com.kvs.ui.FiUI;
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
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
			//通知核心Core新建一个页面
			
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
			
			pageUI.w = scrollProxy.viewWidth;
			pageUI.h = 90;
			
			pageUI.iconW = 90;
			pageUI.iconH = 70;
			
			pageUI.styleXML = pageStyleXML;
			
			pagesCtn.addChild(pageUI);
			pages.push(pageUI);
			
			setCurrentPage(pageUI);
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
			
			if (pageUI == currentPage)
			{
				currentPage.selected = false;
				currentPage = null;
			}
		}
		
		/**
		 * 从页面列表中选择了某个页面
		 */		
		public function pageSelected(pageVO:Object):void
		{
			//通知核心core切换至当前page
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
				pageUI.y = pageUI.pageVO.index * pageUI.h;
				
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
		
		/**
		 * 按下页面，切换至当前页
		 */		
		private function pageClicked(evt:MouseEvent):void
		{
			if (evt.target is PageUI)
			{
				setCurrentPage(evt.target as PageUI);
				pageSelected(evt.target as PageUI);
			}
		}
		
		/**
		 * 将当前page切换到指定页
		 */		
		private function setCurrentPage(pageUI:PageUI):void
		{
			if (currentPage)
			{
				currentPage.selected = false;
			}
			
			if (pageUI)
			{
				currentPage = pageUI;
				currentPage.selected = true;
			}
		}
		
		/**
		 */		
		private var currentPage:PageUI;
		
		
		
		
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
			pagesCtn.addEventListener(MouseEvent.CLICK, pageClicked);
			
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
			StyleManager.drawRect(this, bgStyle);
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
		
		/**
		 */		
		private var pageStyleXML:XML = <states>
											<normal>
												<fill color='#FFFFFF' alpha='1'/>
												<img/>
											</normal>
											<hover>
												<fill color='#DDDDDD' alpha='1'/>
												<img/>
											</hover>
											<down>
												<fill color='#666666'/>
												<img/>
											</down>
										</states>
	}
}