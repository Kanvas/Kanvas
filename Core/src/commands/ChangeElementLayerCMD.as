package commands
{
	import flash.display.DisplayObjectContainer;
	
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;

	public final class ChangeElementLayerCMD extends Command
	{
		public function ChangeElementLayerCMD()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			element = CoreFacade.coreMediator.currentElement;
			parent  = element.parent;
			
			jump     = notification.getBody().jump;
			oldLayer = int(notification.getBody().index);
			newLayer = parent.getChildIndex(element);
			
			UndoRedoMannager.register(this);
		}
		
		override public function undoHandler():void
		{
			if (jump)
			{
				if (parent && element)
					parent.setChildIndex(element, oldLayer);
			}
			else
			{
				if (parent && element) 
					parent.swapChildrenAt(newLayer, oldLayer);
			}
			
			
		}
		
		override public function redoHandler():void
		{
			if (jump)
			{
				if (parent && element)
					parent.setChildIndex(element, newLayer);
			}
			else
			{
				if (parent && element) 
					parent.swapChildrenAt(oldLayer, newLayer);
			}
		}
		
		/**
		 */		
		private var element:ElementBase;
		
		private var oldLayer:int;
		private var newLayer:int;
		private var jump:Boolean;
		
		private var parent:DisplayObjectContainer;
	}
}