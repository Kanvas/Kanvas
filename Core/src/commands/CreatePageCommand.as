package commands
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import model.CoreFacade;
	import model.ElementProxy;
	import model.vo.ElementVO;
	
	import modules.pages.PageElement;
	import modules.pages.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.ElementCreator;
	import util.StyleUtil;
	import util.layout.LayoutTransformer;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;

	public final class CreatePageCommand extends Command
	{
		public function CreatePageCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			//来自于工具面板触发的创建，
			var pageProxy:ElementProxy = notification.getBody() as ElementProxy;
			var layoutTransformer:LayoutTransformer = CoreFacade.coreMediator.layoutTransformer;
			
			// VO 初始化
			pageVO = ElementCreator.getElementVO(pageProxy.type) as PageVO;
			
			pageVO.x = layoutTransformer.stageXToElementX(pageProxy.x);
			pageVO.y = layoutTransformer.stageYToElementY(pageProxy.y);
			pageVO.rotation = pageProxy.rotation;
			pageVO.width = pageProxy.width;
			pageVO.height = pageProxy.height;
			pageVO.styleType = pageProxy.styleType;
			
			// 样式初始化,
			StyleUtil.applyStyleToElement(pageVO, pageProxy.styleID);
			
			// UI 初始化
			page = ElementCreator.getElementUI(pageVO) as ElementBase;
			
			// 新创建图形的比例总是与画布比例互补，保证任何时候创建的图形看起来是标准大小
			pageVO.scale = layoutTransformer.compensateScale;
			
			CoreFacade.addElement(page);
			CoreFacade.coreMediator.pageManager.addPage(pageVO);
			
			//放置拖动创建时 当前原件未被指定 
			CoreFacade.coreMediator.currentElement = page;
			
			//开始缓动，将此设为false当播放完毕且鼠标弹起时进入选择状态
			CoreFacade.coreMediator.createNewShapeTweenOver = false;
			// 图形创建时 添加动画效果
			TweenLite.from(page, pageProxy.flashTime, {alpha: 0, scaleX : 0, scaleY : 0, ease: Back.easeOut, onComplete: shapeCreated});
		}
		
		/**
		 */		
		private function shapeCreated():void
		{
			CoreFacade.coreMediator.autoLayerController.autoLayer(page, true);
			
			index1 = page.index;
			index2 = pageVO.index;
			//动画完毕
			CoreFacade.coreMediator.createNewShapeTweenOver = true;
			if (CoreFacade.coreMediator.createNewShapeTweenOver && CoreFacade.coreMediator.createNewShapeMouseUped)
				sendNotification(Command.SElECT_ELEMENT, page);
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			CoreFacade.removeElement(page);
			CoreFacade.coreMediator.pageManager.removePage(page.vo as PageVO);
		}
		
		override public function redoHandler():void
		{
			CoreFacade.addElementAt(page, index1);
			CoreFacade.coreMediator.pageManager.addPageAt(page.vo as PageVO, index2);
		}
		
		/**
		 */		
		private var page:ElementBase;
		private var pageVO:PageVO;
		
		private var index1:int;
		
		private var index2:int;
	}
}