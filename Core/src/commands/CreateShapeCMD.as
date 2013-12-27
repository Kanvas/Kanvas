package commands
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.geom.Point;
	
	import model.CoreFacade;
	import model.CoreProxy;
	import model.ElementProxy;
	import model.vo.ElementVO;
	import model.vo.ShapeVO;
	
	import modules.pages.PageElement;
	import modules.pages.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.ElementCreator;
	import util.StyleUtil;
	import util.layout.LayoutTransformer;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.Camera;
	import view.element.ElementBase;
	
	/**
	 * 创建形状
	 */
	public class CreateShapeCMD extends Command
	{
		
		
		/**
		 */		
		public function CreateShapeCMD()
		{
			super();
		}
		
		/**
		 */
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			//来自于工具面板触发的创建，
			var elementProxy:ElementProxy = notification.getBody() as ElementProxy;
			var layoutTransformer:LayoutTransformer = CoreFacade.coreMediator.layoutTransformer;
			
			// VO 初始化
			var elementVO:ElementVO = ElementCreator.getElementVO(elementProxy.type);
			
			var point:Point = layoutTransformer.stagePointToElementPoint(elementProxy.x, elementProxy.y);
			elementVO.x = point.x;
			elementVO.y = point.y;
			elementVO.rotation = elementProxy.rotation;
			elementVO.width = elementProxy.width;
			elementVO.height = elementProxy.height;
			elementVO.styleType = elementProxy.styleType;
			
			// 样式初始化,
			StyleUtil.applyStyleToElement(elementVO, elementProxy.styleID);
			
			if (elementVO is ShapeVO)
				(elementVO as ShapeVO).radius = elementProxy.radius;
			
			// UI 初始化
			shapeElement = ElementCreator.getElementUI(elementVO) as ElementBase;
			
			// 新创建图形的比例总是与画布比例互补，保证任何时候创建的图形看起来是标准大小
			elementVO.scale = layoutTransformer.compensateScale;
			(shapeElement is Camera) ? CoreFacade.addElementAt(shapeElement, 1) : CoreFacade.addElement(shapeElement);
			
			//放置拖动创建时 当前原件未被指定 
			CoreFacade.coreMediator.currentElement = shapeElement;
			
			//开始缓动，将此设为false当播放完毕且鼠标弹起时进入选择状态
			CoreFacade.coreMediator.createNewShapeTweenOver = false;
			// 图形创建时 添加动画效果
			TweenLite.from(shapeElement, elementProxy.flashTime, {alpha: 0, scaleX : 0, scaleY : 0, ease: Back.easeOut, onComplete: shapeCreated});
			
			if (shapeElement is PageElement)
			{
				CoreFacade.coreMediator.pageManager.addPage(shapeElement.vo as PageVO);
			}
		}
		
		/**
		 */		
		private function shapeCreated():void
		{
			CoreFacade.coreMediator.autoLayerController.autoLayer(shapeElement);
			elementIndex = CoreFacade.getElementIndex(shapeElement);
			//动画完毕
			CoreFacade.coreMediator.createNewShapeTweenOver = true;
			if (CoreFacade.coreMediator.createNewShapeTweenOver && CoreFacade.coreMediator.createNewShapeMouseUped)
				sendNotification(Command.SElECT_ELEMENT, shapeElement);
			
			UndoRedoMannager.register(this);
			
			
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			CoreFacade.removeElement(shapeElement);
			
			if (shapeElement is PageElement)
			{
				pageIndex = (shapeElement.vo as PageVO).index;
				CoreFacade.coreMediator.pageManager.removePage(shapeElement.vo as PageVO);
			}
		}
		
		override public function redoHandler():void
		{
			CoreFacade.addElementAt(shapeElement, elementIndex);
			if (shapeElement is PageElement)
			{
				CoreFacade.coreMediator.pageManager.addPageAt(shapeElement.vo as PageVO, pageIndex);
			}
		}
		
		/**
		 */		
		private var shapeElement:ElementBase;
		
		private var elementIndex:int;
		
		private var pageIndex:int;
	}
}