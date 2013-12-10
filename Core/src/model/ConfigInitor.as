package model
{
	import com.kvs.utils.Base64;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	
	import commands.Command;
	
	import flash.utils.ByteArray;
	

	/**
	 * 负责加载配置文件, 并初始化配置库
	 */	
	public class ConfigInitor
	{
		/**
		 * 缩放，旋转图标的尺寸；
		 */		
		public static const ICON_SIZE_FOR_SCALE_AND_ROLL:uint = 18;
		
		/**
		 * 缩略图的宽度 
		 */		
		public static const THUMB_WIDTH:uint = 400;
		
		/**
		 * 缩略图的高度 
		 */		
		public static const THUMB_HEIGHT:uint = 300;
		
		
		/**
		 */		
		public function ConfigInitor(core:CoreApp)
		{
			this.core = core;
			initConfig();
		}
		
		/**
		 * 初始化样式配置
		 */		
		protected function initConfig():void
		{
			data = StyleEmbeder.styleXML;
			
			// 注册通用样式元素
			for each (var item:XML in data.child('template').children())
				XMLVOLib.registWholeXML(item.@id, item, item.name().toString());
			
			CoreFacade.coreProxy.initThemeConfig(XML(data.child('themes').toXMLString()));
			core.ready();
		}
		
		/**
		 */		
		public var data:XML;
		
		/**
		 */		
		private var core:CoreApp;
	}
}