package com.kvs.ui.label
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.FontLookup;
	
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.edit.EditingMode;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import model.vo.TextVO;
	
	import util.textFlow.FlowTextManager;
	import util.textFlow.ITextFlowLabel;
	
	/**
	 * 采用文本引擎的最小label单元
	 */	
	public class TextFlowLabel extends Sprite implements ITextFlowLabel
	{
		public function TextFlowLabel()
		{
			super();
			
			addChild(textCanvas);
			textDrawer = new TextDrawer(this);
			
			_textManager = new TextContainerManager(textCanvas);
			_textManager.editingMode = EditingMode.READ_ONLY;
			
			_textLayoutFormat = new TextLayoutFormat;
			_textLayoutFormat.cffHinting = CFFHinting.NONE;
			_textLayoutFormat.textAlign = TextAlign.LEFT;
			_textLayoutFormat.fontLookup = FontLookup.EMBEDDED_CFF;
			
			_textManager.hostFormat = _textLayoutFormat;
		}
		
		/**
		 */		
		public var ifTextBitmap:Boolean = false;
		
		/**
		 */		
		private var textDrawer:TextDrawer;
		
		/**
		 */		
		private var textCanvas:Sprite = new Sprite;
		
		/**
		 * 默认文本采用设备字体模式渲染, 如果需要放大文本，则可以考虑嵌入字体方式渲染
		 */		
		public function renderLabel(textformat:TextFormat, ifUseEmbedFont:Boolean = true):void
		{
			FlowTextManager.render(this, textformat, ifUseEmbedFont);
			
			if (ifTextBitmap)
			{
				var bound:Rectangle = textManager.getContentBounds();
				textDrawer.renderTextBMD(this.graphics, textCanvas, 1, bound.width * .5, bound.height * .5, bound.width, bound.height);
				textDrawer.checkVisible(this.graphics, textCanvas, 1, bound.width * .5, bound.height * .5, bound.width, bound.height);
			}
		}
		
		/**
		 */		
		public function checkTextBm(scale:Number):void
		{
			globleScale = scale;
			
			if (ifTextBitmap)
			{
				var w:Number = textManager.compositionWidth;
				var h:Number = textManager.compositionHeight;
				var bound:Rectangle = textManager.getContentBounds();
				textDrawer.checkTextBm(graphics, textCanvas, globleScale, bound.width * .5, bound.height * .5, bound.width, bound.height);
			}
		}
		
		/**
		 * 记录全局比例
		 */		
		private var globleScale:Number = 1;
		
		/**
		 */
		public function get text():String
		{
			return _text;
		}
		
		/**
		 */		
		private var ifChanged:Boolean = false;
		
		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			if (_text != value)
			{
				_text = value;
				ifChanged = true;
			}
		}
		
		/**
		 */		
		private var _text:String = '';
		
		/**
		 */		
		public function get textLayoutFormat():TextLayoutFormat
		{
			return _textLayoutFormat; 
		}
		
		/**
		 */		
		private var _textLayoutFormat:TextLayoutFormat;
		
		/**
		 */		
		public function get textManager():TextContainerManager
		{
			return _textManager;
		}
		
		/**
		 */		
		private var _textManager:TextContainerManager;
		
		/**
		 */
		public function get ifMutiLine():Boolean
		{
			return _ifMutiLine;
		}
		
		/**
		 */
		public function set ifMutiLine(value:Boolean):void
		{
			_ifMutiLine = value;
		}
		
		/**
		 */		
		private var _ifMutiLine:Boolean = false;
		
		/**
		 */		
		public function get fixWidth():Number
		{
			return _fixWidth;
		}
		
		/**
		 */
		public function set fixWidth(value:Number):void
		{
			_fixWidth = value;
		}
		
		/**
		 */		
		private var _fixWidth:Number = 0;
		
		/**
		 */		
		public function afterReRender():void
		{
			if (ifTextBitmap)
			{
				var bound:Rectangle = textManager.getContentBounds();
				//todo
				textDrawer.renderTextBMD(this.graphics, textCanvas, globleScale, bound.width * .5, bound.height * .5, bound.width, bound.height);
				textDrawer.checkVisible(this.graphics, textCanvas, globleScale, bound.width * .5, bound.height * .5, bound.width, bound.height);
			}
				
		}
	}
}