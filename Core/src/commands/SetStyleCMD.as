package commands
{
	import model.CoreProxy;
	import model.ProxyNames;
	import model.vo.ElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import view.MediatorNames;
	import view.element.ElementBase;
	import view.interact.CoreMediator;
	
	/**
	 */	
	public class SetStyleCMD extends Command
	{
		private var canvasProxy:CoreProxy;
		
		private var canvasMediator:CoreMediator;
		
		private var element:ElementBase;
		
		private var elementVO:ElementVO;
		
		private var oldStyle:XML;
		
		private var newStyle:XML;
		
		/**
		 * 设置样式
		 */
		public function SetStyleCMD()
		{
			super();
		}
		
		/**
		 * 
		 * @param notification
		 * 
		 */
		override public function execute(notification:INotification):void
		{
			canvasProxy = facade.retrieveProxy(ProxyNames.CORE_PROXY) as CoreProxy;
			canvasMediator = facade.retrieveMediator(MediatorNames.CORE_MEDIATOR) as CoreMediator;
			
			if (notification.getBody() is XML)
			{
			}
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
		
		}
		
	}
}