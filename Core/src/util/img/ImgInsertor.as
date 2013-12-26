package util.img
{
	import com.adobe.images.PNGEncoder;
	import com.kvs.utils.system.OS;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	/**
	 * 图片插入器, 负责从客户端选取图片，并上传至指定服务器
	 * 
	 * 上传成功后，返回图片URL和图片的bitmapdata数据
	 * 
	 */	
	public class ImgInsertor extends EventDispatcher
	{
		/**
		 */		
		public function ImgInsertor()
		{
			imgUpLoader = new URLLoader();
			imgUpLoader.dataFormat = URLLoaderDataFormat.BINARY;
			imgUpLoader.addEventListener(IOErrorEvent.IO_ERROR, imgUploadError);
			imgUpLoader.addEventListener(Event.COMPLETE, imgUploadHandler);
		}
		
		/**
		 */		
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			trace('error');
		}
		
		/**
		 * 图片上传过程中，删除图片等于取消上传
		 */		
		public function deleteIMG(imgID:uint):void
		{
			imgUpLoader.close();
		}
		
		/**
		 */		
		public var bitmapData:BitmapData;
		
		/**
		 * 图片ID， 每个图片都会含有一个图片ID， 服务端也会根据此ID记录
		 * 
		 * 图片，由于将来删除图片时作为标识
		 */		
		private var imgID:uint;
		
		
		
		
		//-------------------------------------------------
		//
		//
		// 从服务器加载图片
		//
		//
		//-------------------------------------------------
		
		/**
		 */		
		public function loadImg(url:String, imgID:uint):void
		{
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bmdLoadedFromServerHandler);
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			imgLoader.load(new URLRequest(url));
			
			this.imgID = imgID;
		}
		
		/**
		 * 图片加载成功后，注册至图片库中
		 */		
		private function bmdLoadedFromServerHandler(evt:Event):void
		{
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bmdLoadedFromServerHandler);
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			bitmapData = (imgLoader.content as Bitmap).bitmapData;
			
			this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED_FROM_SERVER, bitmapData, imgID));
			
			ImgLib.register(imgID.toString(), bitmapData);
			bitmapData = null;
		}
		
		
		
		
		
		
		
		
		//----------------------------------------------
		//
		//
		// 
		// 选择并上传图片至服务器
		//
		//
		//
		//----------------------------------------------
		
		/**
		 * 从客户端选择，加载图片, 给图片分配ID
		 */		
		public function insert(imgID:uint):void
		{
			this.imgID = imgID;
			
			fileReference.addEventListener(Event.SELECT, onFileSelected);
			fileReference.browse([new FileFilter("Images", "*.jpg;*.gif;*.png")]);
		}
		
		/**
		 */		
		private function onFileSelected(e:Event):void 
		{
			_chooseSameImage = (lastSelectedImageURL == fileReference.name);
			lastSelectedImageURL = fileReference.name;
			
			fileReference.removeEventListener(Event.SELECT, onFileSelected);
			fileReference.addEventListener(Event.COMPLETE, onFileLoaded);
			
			try
			{
				//载入图片前，先扩充内存，防止图片过大导致的fp崩溃
				OS.enlargeMemory();
				fileReference.load();
			} 
			catch(error:Error) 
			{
				trace('加载图片失败');
			}
		}
		
		/**
		 */		
		private function onFileLoaded(e:Event):void 
		{
			//OS.memoryGc();
			fileReference.removeEventListener(Event.COMPLETE, onFileLoaded);
			
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bmdLoadedFromLocalHandler);
			imgLoader.loadBytes(fileReference.data);
		}
		
		/**
		 */		
		private function bmdLoadedFromLocalHandler(evt:Event):void
		{
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bmdLoadedFromLocalHandler);
			bitmapData = (imgLoader.content as Bitmap).bitmapData;
			
			imgLoader.unload();
			this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED_TO_LOCAL, bitmapData, imgID));
			
			sendImgDataToServer();
		}
		
		/**
		 * 将图片的字节数据发送至服务器, 成功后注册图片到图片库中
		 * 
		 * 服务端返回图片的URL
		 */		
		private function sendImgDataToServer():void
		{
			//服务地址没有配置时，直接显示图片
			if (IMG_SERVER_URL == null)
			{
				imgOK();
			}
			else
			{
				var req:URLRequest = new URLRequest(IMG_SERVER_URL);
				req.method = URLRequestMethod.POST;
				req.contentType = "application/octet-stream";  
				req.data = PNGEncoder.encode(bitmapData);//已png编码格式的图片发送至服务端
				
				//发送图片数据流质服务器
				imgUpLoader.load(req);
			}
			
		}
		
		/**
		 */		
		public function close():void
		{
			lastSelectedImageURL = null;
			try 
			{
				imgUpLoader.close();
			}
			catch (e:Error)
			{
				
			}
		}
		
		/**
		 */		
		private function imgUploadHandler(evt:Event):void
		{
			imgOK();
		}
		
		/**
		 * 
		 */		
		private function imgUploadError(e:IOErrorEvent):void
		{
			imgOK();
		}
		
		/**
		 */		
		private function imgOK():void
		{
			ImgLib.register(imgID.toString(), bitmapData);
			
			var imgURL:String;
			if (imgUpLoader.data)
				imgURL = imgUpLoader.data.toString();
				
			this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_UPLOADED_TO_SERVER, bitmapData, imgID, imgURL));
			
			bitmapData = null;
		}
			
		/**
		 */		
		public function get chooseSameImage():Boolean
		{
			return _chooseSameImage;
		}
		
		/**
		 */		
		private var _chooseSameImage:Boolean;
		
		/**
		 * 图片上传服务
		 */		
		public static var IMG_SERVER_URL:String = null;
		
		/**
		 */		
		private var imgUpLoader:URLLoader = new URLLoader;
		
		/**
		 */		
		private var imgLoader:Loader = new Loader;
		
		/**
		 */		
		private var fileReference:FileReference = new FileReference();
		
		private var lastSelectedImageURL:String;
		
		
	}
}