package commands
{
	
	import flash.geom.Point;
	
	import model.CoreFacade;
	import model.vo.PageVO;
	import model.vo.TextVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.ElementCreator;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.text.TextEditField;
	import view.interact.CoreMediator;
	
	/**
	 * 创建文本框
	 */
	public class CreateTextCMD extends Command
	{
		/**
		 */		
		private var textField:TextEditField;
		
		/**
		 */		
		public function CreateTextCMD()
		{
			super();
		}
		
		/**
		 */
		override public function execute(notification:INotification):void
		{
			this.sendNotification(Command.UN_SELECT_ELEMENT);
			
			var textVO:TextVO = notification.getBody() as TextVO;
			textVO.id = ElementCreator.id;
			
			textField = new TextEditField(textVO);
			
			CoreFacade.addElement(textField);
			
			v = CoreFacade.coreMediator.pageManager.refreshPageThumbsByElement(textField);
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			CoreFacade.removeElement(textField);
			
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
		}
		
		override public function redoHandler():void
		{
			CoreFacade.addElement(textField);
			
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
		}
		
		private var v:Vector.<PageVO>;
	}
}