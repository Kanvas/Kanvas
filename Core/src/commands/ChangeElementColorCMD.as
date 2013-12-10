package commands
{
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;

	/**
	 * 改变元素样式
	 */	
	public final class ChangeElementColorCMD extends Command
	{
		public function ChangeElementColorCMD()
		{
			super();
		}
		
		/**
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			element = CoreFacade.coreMediator.currentElement;
			
			oldColorObj = notification.getBody();
			newColorObj = {color:element.vo.color, colorIndex:element.vo.colorIndex};
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			element.vo.color = oldColorObj.color;
			element.vo.colorIndex = oldColorObj.colorIndex;
			element.render();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			element.vo.color = newColorObj.color;
			element.vo.colorIndex = newColorObj.colorIndex;
			element.render();
		}
		
		/**
		 */		
		private var element:ElementBase;
		
		/**
		 */	
		private var oldColorObj:Object;
		
		/**
		 */	
		private var newColorObj:Object;
	}
}