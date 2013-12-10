package commands
{
	import model.CoreFacade;
	import model.CoreProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.Camera;
	import view.element.ElementBase;
	import view.element.imgElement.ImgElement;
	
	/**
	 * 粘贴元素
	 */
	public class PasteElementCMD extends Command
	{
		/**
		 */		
		public function PasteElementCMD()
		{
			super();
		}
		
		/**
		 */
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			var pastElement:ElementBase = CoreFacade.coreMediator.getElementForPaste();
			
			if (!pastElement)
				return;
			
			newElement = pastElement.clone();
			
			// 为新元素创建，添加偏移
			var dis:Number = CoreFacade.coreMediator.layoutTransformer.stageDisToCanvasDis(10);
			CoreApp.PAST_LOC.x += dis;
			CoreApp.PAST_LOC.y += dis;
			
			newElement.vo.x = CoreApp.PAST_LOC.x; 
			newElement.vo.y = CoreApp.PAST_LOC.y;
			
			//复制元素与原始元素坐标差
			var xOff:Number = newElement.vo.x - pastElement.vo.x;
			var yOff:Number = newElement.vo.y - pastElement.vo.y;
			
			(newElement is Camera) ? CoreFacade.addElementAt(newElement, 1) : CoreFacade.addElement(newElement);
			elementIndex = newElement.index;
			
			autoGroupEnabled = CoreFacade.coreMediator.autoGroupController.enabled;
			if (autoGroupEnabled)
			{
				elementIndexArray = [];
				CoreFacade.coreMediator.autoGroupController.pastElements(xOff, yOff);
				groupElements = CoreFacade.coreMediator.autoGroupController.elements.concat();
				length = groupElements.length;
			}
			
			sendNotification(Command.SElECT_ELEMENT, newElement);
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			if (autoGroupEnabled)
			{
				for (var i:int = length - 1; i >= 0; i--)
				{
					elementIndexArray[i] = groupElements[i].index;
					CoreFacade.removeElement(groupElements[i]);
				}
			}
			
			CoreFacade.removeElement(newElement);
		}
		
		override public function redoHandler():void
		{
			CoreFacade.addElementAt(newElement, elementIndex);
			if (autoGroupEnabled)
			{
				for (var i:int = 0; i < length; i++)
				{
					CoreFacade.addElementAt(groupElements[i], elementIndexArray[i]);
				}
			}
		}
		
		/**
		 */		
		private var groupElements:Vector.<ElementBase>;
		private var length:int;
		private var elementIndexArray:Array;
		
		private var elementIndex:int;
		
		/**
		 */		
		private var newElement:ElementBase;
		
		private var autoGroupEnabled:Boolean;
	}
}