package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * 负责加载主程序
	 */	
	public class KanvasShell extends Sprite
	{
		public function KanvasShell()
		{
			StageUtil.initApplication(this, init);
		}
		
		/**
		 */		
		private function init():void
		{
			this.addChild(logoShape);
			
			var lo:BitmapData = new logo;
			var x:Number = (stage.stageWidth - lo.width / 3) / 2;
			var y:Number = (stage.stageHeight - lo.height / 2) / 2;
		
			BitmapUtil.drawBitmapDataToShape(lo, logoShape, lo.width / 3, lo.height / 3, x, y, true);
			
			laoder = new Loader();
			laoder.contentLoaderInfo.addEventListener(Event.COMPLETE, kanvasLoaded);
			laoder.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErroHander);
			
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = new ApplicationDomain();
			laoder.load(new URLRequest('Kanvas'), context);
		}
		
		/**
		 */		
		private var logoShape:Shape = new Shape;
		
		/**
		 */		
		private function kanvasLoaded(evt:Event):void
		{
			kanvas = laoder.content as Sprite;
			laoder.contentLoaderInfo.removeEventListener(Event.COMPLETE, kanvasLoaded);
			laoder.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErroHander);
			laoder.unload();
			laoder = null;
			
			TweenLite.to(logoShape, 1, {y: stage.stageHeight, alpha: 0, onComplete: removeLogo, ease:Back.easeIn});
		}
		
		/**
		 */		
		private function removeLogo():void
		{
			this.removeChild(logoShape);
			logoShape = null;
			
			addChild(kanvas);
			TweenLite.from(kanvas, 1, {y: - 100, ease: Back.easeInOut});
		}
		
		/**
		 */		
		private function ioErroHander(e:IOErrorEvent):void
		{
			
		}
		
		/**
		 */		
		private var laoder:Loader;
		
		/**
		 */		
		private var kanvas:Sprite;
		
	}
}