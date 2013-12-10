package commands
{
	import model.CoreFacade;
	import model.CoreProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.StyleUtil;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;

	/**
	 * 改变元素的整体样式，包括边框于填充
	 */	
	public class ChangeElementStyleCMD extends Command
	{
		public function ChangeElementStyleCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			element = CoreFacade.coreMediator.currentElement;
			
			oldStyleID = notification.getBody().toString();
			newStyleID = element.vo.styleID;
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			element.vo.styleID = oldStyleID;
			StyleUtil.applyStyleToElement(element.vo);
			element.render();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			element.vo.styleID = newStyleID;
			StyleUtil.applyStyleToElement(element.vo);
			element.render();
		}
		
		private var oldStyleID:String;
		private var newStyleID:String;
		
		/**
		 */		
		private var element:ElementBase;
		
	}
}