package view.pagePanel
{
	import com.kvs.ui.FiUI;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import model.CoreFacade;
	import model.CoreProxy;
	
	import modules.pages.PageEvent;
	import modules.pages.PageManager;
	import modules.pages.PageVO;
	
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
		
		/**
		 * 核心Core初始化完毕后才可以调用此方法
		 */		
		public function initPageManager():void
		{
			this.pageManager = CoreFacade.coreMediator.pageManager;
			
			pageManager.addEventListener(PageEvent.PAGE_ADDED, pageAdded);
			pageManager.addEventListener(PageEvent.UPDATE_PAGES_LAYOUT, layoutPages);
			pageManager.addEventListener(PageEvent.PAGE_DELETED, pagedDeleted);
			
			this.addEventListener(PageEvent.PAGE_SELECTED, pageSelectedFromCore);
		}
		
		/**
		 */		
		private function pageSelectedFromCore(evt:PageEvent):void
		{
			setCurrentPage(findPageUIByVO(evt.pageVO));
			udpateScrollForCurrPage();
		}
		
		/**
		 */		
		private var pageManager:PageManager;
		
		
		
		
		
		
		
		
		//------------------------------------------------
		//
		//
		//
		//  页面操作，包含添加编辑与删除等
		//
		//
		//
		//------------------------------------------------
		
		
		
		/**
		 * 告知core去创建一个页面
		 */		
		public function addPage(evt:MouseEvent):void
		{
			_addPage();
		}
		
		/**
		 * Enter键会触发
		 */		
		private function keyBoardShot(evt:KeyboardEvent):void
		{
			if (evt.keyCode == Keyboard.ENTER)
			{
				_addPage();
			}
		}
		
		/**
		 */		
		private function _addPage():void
		{
			if (currentPage)
				CoreFacade.coreMediator.addPage(currentPage.pageVO.index + 1);
			else
				CoreFacade.coreMediator.addPage(pages.length);
		}
		
		/**
		 * core页面创建成功反馈
		 */		
		public function pageAdded(evt:PageEvent):void
		{
			_pageAdded(evt.pageVO);
		}
		
		/**
		 */		
		private function _pageAdded(pageVO:PageVO):void
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
		public function pagedDeleted(evt:PageEvent):void
		{
			var pageUI:PageUI = findPageUIByVO(evt.pageVO);
			
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
		public function initPages(pages:Vector.<PageVO>):void
		{
			var pageVO:PageVO;
			for each (pageVO in pages)
			{
				_pageAdded(pageVO);
			}
		}
		
		/**
		 * 根据页面的序号重新排列所有页面，并更新序号显示
		 */		
		private function layoutPages(evt:PageEvent):void
		{
			var pageUI:PageUI;
			for each (pageUI in pages)
			{
				pageUI.y = pageUI.pageVO.index * pageUI.h;
				
				pageUI.updataLabel();
			}
			
			scrollProxy.updateScrollBar();
			
			udpateScrollForCurrPage();
		}
		
		/**
		 * 保证当前页可见
		 */		
		private function udpateScrollForCurrPage():void
		{
			if (currentPage)
			{
				scrollProxy.scrollTo(currentPage.y, currentPage.y + currentPage.height);
			}
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
				udpateScrollForCurrPage();
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
		 */		
		private function findPageByIndex(index:int):PageUI
		{
			if (index < 0)
				index = 0;
			else if (index >= pages.length)
				index = pages.length - 1;
				
			var page:PageUI;
			
			for each (page in pages)
			{
				if (page.pageVO.index == index)
					break;
			}
			
			return page;
		}
		
		/**
		 */		
		private var currentPage:PageUI;
		
		
		
		
		
		
		
		//------------------------------------------------
		//
		//
		//
		//  焦距动画控制
		//
		//
		//
		//------------------------------------------------
		
		
		
		/**
		 */		
		public function showCameraShot():void
		{
			stage.addEventListener(Event.ENTER_FRAME, shotFlash);
			
			core.cameraShotShape.alpha = 0;
			core.cameraShotShape.visible = true;
		}
		
		/**
		 */		
		public function hideCanmeraShot():void
		{
			stage.removeEventListener(Event.ENTER_FRAME, shotFlash);
			
			core.cameraShotShape.visible = false;
			core.cameraShotShape.alpha = 0;
		}
		
		/**
		 */		
		private function shotFlash(evt:Event):void
		{
			if (core.cameraShotShape.alpha >= 1)
				adder = - 0.05;
			else if (core.cameraShotShape.alpha <= 0)
				adder = 0.05;
			
			core.cameraShotShape.alpha += adder;
		}
		
		/**
		 */		
		private var adder:Number = 0.1;
		
		
		
		
		
		
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
			
			scrollProxy = new PagesScrollProxy(this);
			XMLVOMapper.fuck(bgStyleXML, bgStyle);
			
			addPageBtn = new ShotBtn(this);
			addPageBtn.w = w - gutter * 2 - 4;
			addPageBtn.h = 100;
			addPageBtn.iconW = 60;
			addPageBtn.iconH = 60;
		    addPageBtn.setIcons('del_up', 'del_over', 'del_down');
			this.addChild(addPageBtn);
			
			addChild(pagesCtn);
			pagesCtn.addEventListener(MouseEvent.CLICK, pageClicked);
			
			this.addEventListener(MouseEvent.ROLL_OVER, startKeyBordListen);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyBoardShot);
			
			updateLayout();
		}
		
		
		/**
		 */		
		private function startKeyBordListen(evt:MouseEvent):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			stage.addEventListener(MouseEvent.CLICK, stageClick);
			
			ifKeyBord = true;
		}
		
		/**
		 */		
		private var ifKeyBord:Boolean = false;
		
		/**
		 */		
		private function stageClick(evt:MouseEvent):void
		{
			if (ifKeyBord && !this.hitTestPoint(evt.stageX, evt.stageY))
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
				ifKeyBord = false;
			}
		}
		
		/**
		 */		
		private function keyHandler(evt:KeyboardEvent):void
		{
			switch(evt.keyCode)
			{
				case Keyboard.DOWN:
				{
					nextPage();
					break;
				}
				case Keyboard.RIGHT:
				{
					nextPage();
					break;
				}
				case Keyboard.UP:
				{
					prevPage();
					break;
				}
				case Keyboard.LEFT:
				{
					prevPage();
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		private function nextPage():void
		{
			if (currentPage)
				setCurrentPage(findPageByIndex(currentPage.pageVO.index + 1));
			else
				setCurrentPage(findPageByIndex(0));
			
			udpateScrollForCurrPage();
		}
		
		private function prevPage():void
		{
			if (currentPage)
				setCurrentPage(findPageByIndex(currentPage.pageVO.index - 1));
			else
				setCurrentPage(findPageByIndex(0));
			
			udpateScrollForCurrPage();
		}
		
		/**
		 */		
		public function updateLayout():void
		{
			render();
			
			addPageBtn.x = (w - addPageBtn.w) / 2;
			addPageBtn.y = h - addPageBtn.h - gutter;
			
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
	    internal var addPageBtn:ShotBtn;
		
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