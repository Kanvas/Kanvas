package model
{
	import com.adobe.images.PNGEncoder;
	import com.kvs.utils.Map;
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	
	import commands.Command;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import model.vo.BgVO;
	import model.vo.ElementVO;
	import model.vo.ImgVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import util.ElementCreator;
	import util.StyleUtil;
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	import util.img.ImgLib;
	import util.img.PNGDecoder;
	import util.zip.ZipEntry;
	import util.zip.ZipFile;
	import util.zip.ZipOutput;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.element.imgElement.ImgElement;
	
	/**
	 * 负责数据，样式整体控制;
	 * 
	 * 数据解析，生成，样式应用等
	 */
	public class CoreProxy extends Proxy
	{
		
		/**
		 */		
		public function CoreProxy(proxyName:String = null, data:Object = null)
		{
			super(proxyName, data);
			
			
		}
		
		
		
		
		//------------------------------------------------
		//
		//
		//  样式控制
		//
		//
		//------------------------------------------------
		
		/**
		 * 
		 * 重绘所有元件
		 */		
		public function renderElements():void
		{
			for each (var element:ElementBase in this.elements)
			{
				applyStyleToElement(element.vo);
				element.render();
			}
		}
		
		/**
		 * 更新全局样式模型
		 */		
		public function setCurrTheme(name:String):void
		{
			currStyle = name;
			
			var style:XML = themeConfigMap.getValue(name) as XML;
			
			//生效当前样式模板
			XMLVOLib.clearPartLib();
			for each (var item:XML in style.children())
				XMLVOLib.registerPartXML(item.@styleID, item, item.name().toString());
				
			// 更新背景颜色数据	
			bgColorsXML = XMLVOLib.getXML('bg', 'colors') as XML;
			
			//获取模板中背景颜色的序号
			XMLVOMapper.fuck(XMLVOLib.getXML('bg', 'bg'), bgVO);
			updateBgColor();
		}
		
		/**
		 * 根据新颜色位置更新颜色值
		 */		
		public function updateBgColor():void
		{
			bgVO.color = StyleManager.setColor(bgColorsXML.children()[bgVO.colorIndex].toString());
		}
		
		/**
		 */		
		public var bgColorsXML:XML;
		
		/**
		 * 获取背景色
		 */		
		public function get bgColor():uint
		{
			return uint(bgVO.color);
		}
		
		/**
		 */		
		public function get bgColorIndex():uint
		{
			return bgVO.colorIndex;
		}
		
		/**
		 */		
		public function set bgColorIndex(value:uint):void
		{
			bgVO.colorIndex = value;
		}
		
		/**
		 */		
		public var bgVO:BgVO = new BgVO;
		
		/**
		 * 是否拥有此样式，防止无效的渲染
		 */		
		public function isHasStyle(style:String):Boolean
		{
			return themeConfigMap.containsKey(style)
		}
		
		/**
		 * 当前样式模板ID
		 */		
		public var currStyle:String = '';
		
		/**
		 * 初始化样式模板配置文件， 以样式名为ID存储下来，方便
		 * 
		 * 切换样式风格
		 */		
		public function initThemeConfig(value:XML):void
		{
			themeConfigMap.clear();
			
			for each(var item:XML in value.children())
				themeConfigMap.put(item.name().toString(), item);
		}
		
		/**
		 * 全局样式模板
		 */		
		private var themeConfigMap:Map = new Map;
		
		/**
		 * 根据元素的局部样式ID, 获取样式定义，同步至元件上;
		 * 
		 * 先应用样式模板，然后再应用颜色，因为有些元素除了样式模板外还有自定义颜色
		 */		
		public function applyStyleToElement(elementVO:ElementVO, styleID:String = null):void
		{
			StyleUtil.applyStyleToElement(elementVO, styleID);
		}

		
		
		
		
		
	
		
		
		
		//------------------------------------------
		//
		//
		// 数据导入导出
		//
		//
		//------------------------------------------
		
		/**
		 * 将所有资源打包
		 */		
		public function exportZipData():ByteArray
		{
			var zipOut:ZipOutput = new ZipOutput();
			
			// file info
			var fileData:ByteArray = new ByteArray();
			fileData.writeUTFBytes(exportData().toXMLString());
			
			// 添加XMl数据
			var ze:ZipEntry = new ZipEntry('kvs.xml');
			zipOut.putNextEntry(ze);
			zipOut.write(fileData);
			zipOut.closeEntry();
			
			//图片相关
			var imgIDs:Array = ImgLib.imgKeys;
			var imgDataBytes:ByteArray;
			
			var bmd:BitmapData = CoreFacade.coreMediator.mainUI.thumbManager.getShotCut(ConfigInitor.THUMB_WIDTH, ConfigInitor.THUMB_HEIGHT);
			
			if (bmd)
			{
				//缩略图
				ze = new ZipEntry(ImgLib.PRE_IMG + '.png');
				
				fileData.clear();
				imgDataBytes = PNGEncoder.encode(bmd);
				fileData.writeBytes(imgDataBytes, fileData.position, imgDataBytes.bytesAvailable);
				
				zipOut.putNextEntry(ze);
				zipOut.write(fileData);
				zipOut.closeEntry();
			}
			
			// 添加图片资源数据
			for each (var imgID:uint in imgIDs)
			{
				fileData.clear();
				imgDataBytes = PNGEncoder.encode(ImgLib.getData(imgID));//以png格式存储图片
				fileData.writeBytes(imgDataBytes, fileData.position, imgDataBytes.bytesAvailable);
				
				ze = new ZipEntry(imgID.toString() + '.png');
				zipOut.putNextEntry(ze);
				zipOut.write(fileData);
				zipOut.closeEntry();
			}
			
			
			// end the zip
			zipOut.finish();
			
			return zipOut.byteArray;
		}
		
		/**
		 */		
		public function importZipData(byte:ByteArray):void
		{
			var entry:ZipEntry;
			var data:ByteArray;
			var zipFile:ZipFile = new ZipFile(byte);
			
			// xml文件
			entry = zipFile.getEntry('kvs.xml');
			data = zipFile.getInput(entry);
			
			var s:String = data.toString();			
			var xml:XML = XML(s);
			
			var index:uint = zipFile.entries.indexOf(entry);
			zipFile.entries.splice(index, 1);
			
			// 图片资源
			var imgEnties:Array = zipFile.entries;
			var imgID:String;
			for each (entry in imgEnties)
			{
				data = zipFile.getInput(entry);
				
				imgID = entry.name.split('.')[0].toString();
				
				if (uint(imgID) != 0)
					ImgLib.register(imgID, PNGDecoder.decodeImage(data));
			}
			
			importData(xml);
		}
		
		/**
		 */		
		private var zipFile:ZipFile;
		
		/**
		 * 数据导出
		 */
		public function exportData():XML
		{
			CoreFacade.coreMediator.editMode.toUnSelectedMode();
			
			var xml:XML = dataXML.copy();
			
			//样式ID
			xml.header.@styleID = currStyle;
			var mainNode:XMLList = xml.child('main');
			
			// 先根据图层关系排列原件
			elementsWidthIndex.length = 0;
			elementsWidthIndex.length = elements.length;
			
			var canvas:Sprite = CoreFacade.coreMediator.canvas;
			
			for each (var item:ElementBase in elements)
			{
				//图层 － 1 是因为canvas最底层有个拖动交互元素
				elementsWidthIndex[canvas.getChildIndex(item) - 1] = item;
			}
			
			for each (item in elementsWidthIndex)
				mainNode.appendChild(item.exportData());
			
			// 背景设置
			xml.appendChild(bgVO.xml);
				
			return xml;
		}
		
		/**
		 * 数据在导出前，先要根据图层关系重新排位，放置再导入时图层关系错乱
		 */		
		private var elementsWidthIndex:Vector.<ElementBase> = new Vector.<ElementBase>;
		
		/**
		 * 所有数据映射
		 */
		public function importData(xml:XML):void
		{
			temElementMap.clear();
			
			//先设置总体样式风格
			setCurrTheme(xml.header.@styleID);
			//更新文本编辑器样式属性
			CoreFacade.coreMediator.mainUI.textEditor.initStyle();
			// 通知UI更新
			CoreFacade.coreMediator.mainUI.themeUpdated(xml.header.@styleID);
			CoreFacade.coreMediator.mainUI.bgColorsUpdated(bgColorsXML);
			
			//先创建所有元素，再匹配组合关系
			var groupElements:Array = [];
			var element:ElementBase;
			var item:XML;
			for each(item in xml.main.children())
			{
				element = createElement(item);//创建并初始化元素
				if (element is GroupElement)
				{
					element.xmlData = item;
					groupElements.push(element);
				}
			}
			
			//匹配组合关系
			for each(var groupElement:GroupElement in groupElements)
			{
				for each(item in groupElement.xmlData.children())
				{
					element = temElementMap.getValue(item.@id.toString());		
					element.toGroupState();
					groupElement.childElements.push(element);
				}
			}
			
			//清空用于临时匹配组合的中专站
			temElementMap.clear();
			groupElements.length = 0;
			groupElements = null;
			
			for each (element in this.elements)
				element.render();
			
			//处理背景颜色绘制
			XMLVOMapper.fuck(xml.bg, bgVO);
			updateBgColor();
			sendNotification(Command.RENDER_BG_COLOR, bgColor);
			CoreFacade.coreMediator.mainUI.bgColorUpdated(bgColorIndex);
			ElementCreator.setID(bgVO.imgID);
			
			//背景图片加载
			if (RexUtil.ifHasText(bgVO.imgURL) && bgVO.imgURL != 'null')
			{
				bgImgLoader.addEventListener(ImgInsertEvent.IMG_LOADED_FROM_SERVER, initializeBgImgLoaded);
				bgImgLoader.loadImg(bgVO.imgURL, bgVO.imgID);
			}
			else if (ImgLib.ifHasData(bgVO.imgID))//从资源包种获取图片
			{
				renderBgImg(ImgLib.getData(bgVO.imgID));
			}
		}
		
		/**
		 * 数据导入时，辅助组合将子元素纳入组合中
		 */		
		private var temElementMap:Map = new Map;
		
		/**
		 */		
		public function createElement(item:XML):ElementBase
		{
			var vo:ElementVO = ElementCreator.getElementVO(item.name().toString());
			
			XMLVOMapper.fuck(item, vo);
			applyStyleToElement(vo);
			
			//再次应用xml中的属性，为了兼容旧数据的颜色，字体大小等属性；
			XMLVOMapper.fuck(item, vo);
			
			ElementCreator.setID(vo.id);
			
			if (vo is ImgVO)
				ImgLib.setID((vo as ImgVO).imgID); 
			
			var element:ElementBase = ElementCreator.getElementUI(vo);
			
			//虽然添加到了显示列表，但元素未渲染，因为未设定样式
			CoreFacade.addElement(element);
			
			temElementMap.put(vo.id.toString(), element);
			
			return element;
		}
		
		/**
		 * 背景图片加载ok
		 */		
		private function initializeBgImgLoaded(evt:ImgInsertEvent):void
		{
			bgImgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED_FROM_SERVER, initializeBgImgLoaded);
			(evt.bitmapData);
			
			CoreFacade.coreMediator.mainUI.drawBGImg(evt.bitmapData);
			CoreFacade.coreMediator.mainUI.bgImgUpdated(evt.bitmapData);
		}
		
		/**
		 */		
		private function renderBgImg(img:BitmapData):void
		{
			bgVO.imgData = img;
			
			CoreFacade.coreMediator.mainUI.drawBGImg(img);
			CoreFacade.coreMediator.mainUI.bgImgUpdated(img);
		}
		
		/**
		 */		
		public function get backgroundImageLoader():ImgInsertor
		{
			return bgImgLoader;
		}
		
		/**
		 */		
		private var bgImgLoader:ImgInsertor = new ImgInsertor;
		
		/**
		 */		
		private var dataXML:XML = <kanvas>
									<header version = '3.0' styleID={currStyle}/>
									<module/>
									<main/>
								  </kanvas>;
		
		
			
			
			
			
			
			
			
		//------------------------------------------
		//
		//
		//  数据对象的基本操作API
		//
		//
		//------------------------------------------
			
			
		/**
		 * 添加元素
		 */
		public function addElement(value:ElementBase):void
		{
			elements.push(value);
		}
		
		public function addElementAt(element:ElementBase, index:int):void
		{
			elements.splice(index, 0, element);
		}
		
		/**
		 * 删除元素
		 */
		public function removeElement(value:ElementBase):void
		{
			try
			{
				var index:int = elements.indexOf(value);
				if (index != -1)
				{
					elements.splice(index, 1);
				}
			}
			catch (err:Error)
			{
				
			}
		}
		
		/**
		 *删除所有元素 
		 */
		public function clear():void
		{
			this.elements.length = 0;
		}
		
		/**
		 * 设置所有元素
		 */
		public function set elements(value:Vector.<ElementBase>):void 
		{
			_elements = value;
		}
		
		/**
		 * 获取所有元素
		 */
		public function get elements():Vector.<ElementBase> 
		{
			return _elements;
		}
		
		/**
		 * 所有元素VO
		 */
		private var _elements:Vector.<ElementBase> = new Vector.<ElementBase>();
		
		/**
		 * 存放所有的图片元素
		 */		
		//private var _imageElements:Vector.<ImageElement>;
		
		public function get imageElements():Vector.<ImgElement>
		{
			var vector:Vector.<ImgElement> = new Vector.<ImgElement>;
			for each (var element:ElementBase in elements)
			{
				if (element is ImgElement)
					vector.push(element as ImgElement);
			}
			return vector;
		}
		
		/*public function set imageElements(value:Vector.<ImageElement>):void
		{
			_imageElements = value;
		}*/
		
		
	}
}