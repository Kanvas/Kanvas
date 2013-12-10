package commands
{
	import model.CoreFacade;
	import model.CoreProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;

	/**
	 * 设置样式模板
	 */	
	public class SetThemeCMD extends Command
	{
		public function SetThemeCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
				
			proxy = CoreFacade.coreProxy;
			
			oldStyle = proxy.currStyle;
			newStyle = notification.getBody().toString();
			
			if (setStyle(newStyle)) 
				UndoRedoMannager.register(this);
		}
		
		override public function undoHandler():void
		{
			setStyle(oldStyle);
		}
		
		override public function redoHandler():void
		{
			setStyle(newStyle);
		}
		
		/**
		 */		
		private function setStyle(value:String):Boolean
		{
			var result:Boolean = proxy.isHasStyle(value);
			
			if (result)
			{
				//更新图形和背景的样式信息
				proxy.setCurrTheme(value);
				
				//绘制所有图形  
				proxy.renderElements();
				
				//更新文本编辑器样式属性
				CoreFacade.coreMediator.mainUI.textEditor.initStyle();
				
				//绘制背景
				sendNotification(Command.RENDER_BG_COLOR, proxy.bgColor);
				
				// 通知UI更新
				CoreFacade.coreMediator.mainUI.themeUpdated(value);
				CoreFacade.coreMediator.mainUI.bgColorsUpdated(proxy.bgColorsXML);
				CoreFacade.coreMediator.mainUI.bgColorUpdated(proxy.bgColorIndex);
				
			}
			
			return result;
		}
		
		/**
		 */		
		private var oldStyle:String = '';
		private var newStyle:String;
		
		private var proxy:CoreProxy;
	}
}