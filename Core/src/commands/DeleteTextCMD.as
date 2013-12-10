package commands
{
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.text.TextEditField;

	/**
	 * 删除文本
	 */	
	public class DeleteTextCMD extends Command
	{
		public function DeleteTextCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			textLabel = notification.getBody() as TextEditField;
			elementIndex = CoreFacade.getElementIndex(textLabel);
			
			CoreFacade.removeElement(textLabel);
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			CoreFacade.addElementAt(textLabel, elementIndex);
			
			// 文本被删除时可能处于编辑状态， 所以撤销后需要重绘一下
			// 编辑状态的文本看不到，本身没有绘制
			textLabel.render();
		}
		
		override public function redoHandler():void
		{
			CoreFacade.removeElement(textLabel);
		}
		
		/**
		 */		
		private var textLabel:TextEditField;
		
		private var elementIndex:int;
	}
}