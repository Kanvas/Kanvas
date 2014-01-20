package
{
	import com.kvs.utils.Base64;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	import landray.kp.core.KPPresenter;
	import landray.kp.utils.CoreUtil;
	
	import view.toolBar.Debugger;
	
	/**
	 * KPlayer主容器类
	 */
	public class KPlayer extends Sprite
	{
		
		/**
		 * 构造函数。
		 */
		public function KPlayer()
		{
			super();
			//注册初始化函数，容器添加至舞台后调用
			CoreUtil.initApplication(this, initialize, true);
		}
		
		
		
		
		
		//---------------------------------------------------------------------------
		// JS回调函数
		// 提供外层网页容器调用
		//---------------------------------------------------------------------------
		
		/**
		 * @private
		 * js回调函数，传入一个URL，然后通过URL获取数据
		 * 
		 * @param value 传入的地址
		 */
		private function loadDataFromServer(value:String):void
		{
			try  
			{
				if (value) 
				{
					//传入的参数为URL
					isURL = true;
					sData = value;
					//kplayer presenter初始化
					presenter.start(this, appID, isURL, sData);
				}
			}
			catch (e:Error) { }
		}
		
		/**
		 * @private
		 * js回调函数，传入一个XML String
		 * 
		 * @param value 传入的XML String
		 */
		private function setXMLData(value:String):void
		{
			if (value) 
			{
				//传入的参数不为URL
				isURL = false;
				sData = value;
				//kplayer presenter初始化
				presenter.start(this, appID, isURL, sData);
			}
		}
		
		/**
		 * @private
		 * js回调函数，传入一个BASE64加密的XML String
		 * 
		 * @param value 传入的加密XML String
		 */
		private function setBase64Data(value:String, ifCompress:Boolean = true):void
		{
			if (value) 
			{
				//传入的参数不为URL
				isURL = false;
				//处理外部传入的BASE64压缩数据
				var newByte:ByteArray = Base64.decodeToByteArray(value);
				
				if (ifCompress)
					newByte.uncompress();
				
				sData = String(newByte.toString());
				//kplayer presenter初始化
				presenter.start(this, appID, isURL, sData);
			}
		}
		
		/**
		 * @private
		 * js回调函数，当在网页中为transparent，鼠标滚轮会不起作用，此时从JS模拟FLASH鼠标滚轮事件
		 */
		private function onWebMouseWheel(value:int):void
		{
			stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false, NaN, NaN, null, false, false, false, false, value));
		}
		
		/**
		 * @private
		 * js回调函数，画布横向移动一段距离
		 */
		private function horizontalMove(value:Number):void
		{
			presenter.horizontalMove(value);
		}
		
		/**
		 * @private
		 * js回调函数，取消元素的选择状态
		 */
		private function unselected():void
		{
			presenter.unselected();
		}
		
		/**
		 * @private
		 * js回调函数，取消元素的选择状态
		 */
		private function setStartOriginalScale(scale:Boolean):void
		{
			presenter.setStartOriginalScale(scale);
		}
		
		
		//===========================================================================
		// start the app,
		// call presenter.start(container, path) to start.
		// container here is this.
		//===========================================================================
		
		/**
		 * @private
		 * 
		 */
		private function initialize():void
		{
			//initDebugger();
			
			Debugger.debug("初始化");
			//从网页获取ID参数
			appID = (loaderInfo.parameters.id) ? loaderInfo.parameters.id : "1";
			//安全沙箱
			Security.allowDomain("*");
			//初始化presenter，Kplayer主入口类
			presenter = KPPresenter.instance;
			//添加JS回调函数
			addJSCallBack();
			
			//调用READY方法通知网页kplayer已准备完毕
			if (ExternalInterface.available) 
				ExternalInterface.call("KANVAS.ready", appID);
		}
		
		/**
		 * @private
		 * 注册JS回调函数
		 */
		private function addJSCallBack():void
		{
			if (ExternalInterface.available) 
			{
				//传入一个URL，然后通过URL获取数据
				ExternalInterface.addCallback("loadDataFromServer"   , loadDataFromServer);
				//传入一个XML String数据
				ExternalInterface.addCallback("setXMLData"           , setXMLData);
				//传入一个通过BASE64和BYTEARRAY压缩的XML String
				ExternalInterface.addCallback("setBase64Data"        , setBase64Data);
				//模拟鼠标滚轮
				ExternalInterface.addCallback("onWebMouseWheel"      , onWebMouseWheel);
				
				ExternalInterface.addCallback("horizontalMove"       , horizontalMove);
				
				ExternalInterface.addCallback("unselected"           , unselected);
				
				ExternalInterface.addCallback("setStartOriginalScale", setStartOriginalScale)
			}
		}
		
		private function stringToBase64(value:String):String
		{
			var bytes:ByteArray = new ByteArray;
			bytes.writeUTFBytes(value);
			bytes.compress();
			return Base64.encodeByteArray(bytes);
		}
		
		private function initDebugger():void
		{
			if(!debugger)
				addChild(debugger = new Debugger);
		}
		
		/**
		 * @private
		 */
		private var sData:String;
		
		/**
		 * @private
		 */
		private var appID:String;
		
		/**
		 * @private
		 */
		private var isURL:Boolean;
		
		/**
		 * @private
		 * kplayer 主程序主入口
		 */
		private var presenter:KPPresenter;
		
		private var debugger:Debugger;
	}
}