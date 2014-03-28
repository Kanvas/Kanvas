package 
{
	import commands.InsertImgCMDBase;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	import util.img.ImgLib;

	/**
	 * 
	 * @author wallenMac
	 * 
	 * 桌面版本下的插入图片
	 * 
	 */	
	public class InsertIMGFromAIR extends InsertImgCMDBase
	{
		public function InsertIMGFromAIR()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			file.browse([new FileFilter("Images", "*.jpg;*.png")]);
			file.addEventListener(Event.SELECT, fileSelected);
			
		}
		
		/**
		 */		
		private function fileSelected(evt:Event):void
		{
			var filestream:FileStream = new FileStream;
			filestream.open(file, FileMode.READ);
			
			var bytes:ByteArray = new ByteArray;
			filestream.readBytes(bytes, 0, file.size);
				
			imgExtractor = new ImageExtractor(bytes);
			imageLoader.addEventListener(ImgInsertEvent.IMG_LOADED, imgLoaded);
			imageLoader.loadImgBytes(bytes);
		}
		
		/**
		 */		
		private function imgLoaded(evt:ImgInsertEvent):void
		{
			var bmd:BitmapData = evt.bitmapData;
			var imgID:uint = ImgLib.imgID;
			
			createImg(evt.bitmapData, imgID);
			
			ImgLib.register(imgID.toString(), imgExtractor.bytes);
				
			imgElement.toNomalState();
		}
		
		/**
		 */		
		private var imageLoader:ImgInsertor = new ImgInsertor;
		
		/**
		 */		
		private var imgExtractor:ImageExtractor;
		
		/**
		 */		
		private var file:File = new File;
		
	}
}