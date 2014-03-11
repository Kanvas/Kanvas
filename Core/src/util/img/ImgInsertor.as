package util.img
{
	import com.adobe.images.PNGEncoder;
	import com.kvs.utils.graphic.BitmapUtil;
	import com.kvs.utils.system.OS;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.events.Request;

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
			
			imageByteLoader.dataFormat = URLLoaderDataFormat.BINARY;
			imageByteLoader.addEventListener(Event.COMPLETE, imgByteLoaeded);
			imageByteLoader.addEventListener(IOErrorEvent.IO_ERROR, imgByteLoadError);
		}
		
		/**
		 * 从服务端加载图片数据流错误
		 */		
		private function imgByteLoadError(e:IOErrorEvent):void
		{
			this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED_ERROR));
		}
		
		/**
		 */		
		private var imageByteLoader:URLLoader = new URLLoader;
		
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
		public function loadImg(url:String, imgID:uint, w:Number = 0, h:Number = 0):void
		{
			if (isLoading == false)
			{
				this.imgID = imgID;
				
				//旧图片数据需要记录图片的宽高信息，以便生成正确的bitmapdata
				temW = w;
				temH = h;
				
				if (url.indexOf("http:") != 0)
					url = IMG_DOMAIN_URL + url;
				
				var req:URLRequest = new URLRequest(url);
				req.method = URLRequestMethod.GET;
				req.contentType = "application/octet-stream";  
				imageByteLoader.load(req);
				
				isLoading = true;
			}
		}
		
		private var temW:Number;
		private var temH:Number;
		
		/**
		 * 从服务器加载到图片的数据流
		 */		
		private function imgByteLoaeded(evt:Event):void
		{
			//这里做了兼容处理，如果加载失败则可能是旧的图片数据
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bmdLoadedFromServerHandler);
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgLoadIoError);
			
			try
			{
				imgLoader.loadBytes(imageByteLoader.data)
			} 
			catch(error:Error) 
			{
				this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED_ERROR));
			}
		}
		
		/**
		 * 数据为旧图片数据时也可能导致io错误
		 */		
		private function imgLoadIoError(e:IOErrorEvent):void
		{
			isLoading = false;
			
			if (imageByteLoader.data)
			{
				try
				{
					var data:ByteArray = imageByteLoader.data as ByteArray;
					data.uncompress();
					
					imageByteLoader.data.position = 0;
					var bmd:BitmapData = new BitmapData(temW, temH);
					bmd.setPixels(new Rectangle(0, 0, bmd.width, bmd.height), imageByteLoader.data);
					
					(imageByteLoader.data as ByteArray).clear();// 清空数据
					
					//图片加载完毕
					imageLoaedEnd(bmd);
				} 
				catch(error:Error) 
				{
					this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED_ERROR));
				}
			}
		}
		
		/**
		 */		
		public var isLoading:Boolean = false;
		
		/**
		 * 图片加载成功后，注册至图片库中
		 */		
		private function bmdLoadedFromServerHandler(evt:Event):void
		{
			(imageByteLoader.data as ByteArray).clear();// 清空数据
			
			imageLoaedEnd((imgLoader.content as Bitmap).bitmapData);
			
			imgLoader.unload();
		}
		
		/**
		 */		
		private function imageLoaedEnd(bmd:BitmapData):void
		{
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bmdLoadedFromServerHandler);
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgLoadIoError);
			
			this.dispatchEvent(new ImgInsertEvent(ImgInsertEvent.IMG_LOADED_FROM_SERVER, bmd, imgID));
			
			ImgLib.register(imgID.toString(), bmd);
			bitmapData = null;
			
			isLoading = false;
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
			if (IMG_UPLOAD_URL == null)
			{
				imgOK();
			}
			else
			{
				var req:URLRequest = new URLRequest(IMG_UPLOAD_URL);
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
		public static var IMG_UPLOAD_URL:String = null;
		
		public static var IMG_DOMAIN_URL:String = "";
		
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