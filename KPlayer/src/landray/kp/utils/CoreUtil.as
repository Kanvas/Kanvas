package landray.kp.utils
{
	import com.kvs.utils.ClassUtil;
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import landray.kp.core.KPConfig;
	import landray.kp.core.kp_internal;
	import landray.kp.view.Viewer;
	
	import model.CoreProxy;
	import model.vo.ElementVO;
	
	import util.StyleUtil;
	import util.img.ImgLib;

	/**
	 */	
	public class CoreUtil
	{
		
		/**
		 */		
		public static function applyStyle(vo:ElementVO, stypeID:String=null):void
		{
			StyleUtil.applyStyleToElement(vo, stypeID);
		}
		
		public static function clearLibPart(lib:XMLVOLib=null):void
		{
			if(!lib) 
				lib = XMLVOLib.currentLib;
			lib.clearPartLib();
		}
		
		public static function drawBitmapDataToShape(bmd:BitmapData, ui:Shape, w:Number, h:Number, tx:Number = 0, ty:Number = 0, smooth:Boolean = true, radius:uint = 0):void
		{
			BitmapUtil.drawBitmapDataToShape(bmd, ui, w, h, tx, ty, smooth, radius);
		}
		
		public static function getObjByClassPath(path:String):Object
		{
			return ClassUtil.getObjectByClassPath(path);
		}
		
		public static function getStyle(key:String, type:String):*
		{
			return XMLVOLib.getXML(key, type);
		}
		
		public static function ifHasText(value:Object):Boolean
		{
			return RexUtil.ifHasText(value);
		}
		
		public static function imageLibGetData(value:uint):BitmapData
		{
			return ImgLib.getData(value);
		}
		
		public static function imageLibHasData(value:uint):Boolean
		{
			return ImgLib.ifHasData(value);
		}
		
		public static function initApplication(container:Sprite, handler:Function, isMain:Boolean = false):void
		{
			StageUtil.initApplication(container, handler, isMain);
		}
		
		public static function mapping(obj:*, vo:*, parentVO:ElementVO=null):void
		{
			XMLVOMapper.fuck(obj, vo, parentVO);
		}
		
		public static function registLib(lib:XMLVOLib):void
		{
			XMLVOLib.currentLib = lib;
		}
		
		public static function registLibXMLWhole(key:String, xml:*, type:String, lib:XMLVOLib=null):void
		{
			if(!lib) 
				lib = XMLVOLib.currentLib;
			lib.registWholeXML(key, xml, type);
		}
		
		public static function registLibXMLPart(key:String, xml:*, type:String, lib:XMLVOLib=null):void
		{
			if(!lib) 
				lib = XMLVOLib.currentLib;
			lib.registerPartXML(key, xml, type);
		}
		
		public static function setColor(value:Object):Object
		{
			return StyleManager.setColor(value);
		}
	}
}