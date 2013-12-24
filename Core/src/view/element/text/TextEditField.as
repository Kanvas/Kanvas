package view.element.text
{
	import com.kvs.ui.label.TextDrawer;
	import com.kvs.utils.XMLConfigKit.style.elements.TextFormatStyle;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.engine.CFFHinting;
	
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.edit.EditingMode;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import model.vo.ElementVO;
	import model.vo.TextVO;
	
	import util.textFlow.FlowTextManager;
	import util.textFlow.ITextFlowLabel;
	
	import view.element.ElementBase;
	import view.element.IEditElement;
	import view.element.state.ElementGroupState;
	import view.element.state.ElementMultiSelected;
	import view.element.state.IEditShapeState;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	
	
	/**
	 * 文本框， 有三种状态， 非选择状态(usualState), 选择状态(selectedState)， 编辑状态(editState)
	 */
	public class TextEditField extends ElementBase implements IEditElement, ITextFlowLabel, IAutoGroupElement
	{
		
		/**
		 */		
		public function TextEditField(vo:ElementVO)
		{
			super(vo);
			
			textDrawer = new TextDrawer(this);
			xmlData = <text/>
		}
		
		/**
		 * 负责将文本绘制为位图 
		 */		
		private var textDrawer:TextDrawer;
		
		/**
		 */			
		override public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.text);
		}
		
		/**
		 */		
		override public function exportData():XML
		{
			xmlData = super.exportData();
			
			xmlData.@ifMutiLine = textVO.ifMutiLine;
			xmlData.@text = textVO.text;
			
			xmlData.@font = (textVO.label.format as TextFormatStyle).font;
			
			return xmlData;
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var textVO:TextVO = new TextVO;
			
			textVO.text = this.textVO.text;
			textVO.ifMutiLine = this.textVO.ifMutiLine;
			textVO.styleID = this.textVO.styleID;
			
			return new TextEditField(cloneVO(textVO) as TextVO);
		}
		
		
		
		
		
		
		
		//---------------------------------------------
		//
		//
		// 文字状态切换
		//
		//
		//----------------------------------------------
		
		/**
		 */		
		override public function toSelectedState():void
		{
			curTextState.toSelected();
		}
		
		/**
		 * 进入没选中状态
		 */
		override public function toUnSelectedState():void
		{
			curTextState.toUnSelected();
		}
		
		/**
		 * 文字进入编辑模式
		 */
		public function toEditState():void
		{
			curTextState.toEditState();
		}
		
		/**
		 */		
		override protected function initState():void
		{
			selectedState = new TextSelectState(this);
			unSelectedState = new TextUnselectedState(this);
			editTextState = new TextEditState(this);
			multiSelectedState = new TextMutiSelectedState(this);
			groupState = new TextGroupState(this); 
			prevState = new TextPrevState(this);
			
			currentState = unSelectedState;
		}
		
		/**
		 */		
		private function get curTextState():IEditShapeState
		{
			return currentState as IEditShapeState
		}
		
		/**
		 * 编辑状态
		 */
		internal var editTextState:IEditShapeState;
		
		
		
		
		
		
		//---------------------------------------------------------
		//
		//
		//
		//  文字渲染
		// 
		//
		//
		//---------------------------------------------------------
		
		
		/**
		 */		
		public function get text():String
		{
			return textVO.text;
		}
		
		/**
		 */		
		public function set text(value:String):void
		{
			textVO.text = value;
		}
		
		/**
		 * 渲染文字
		 */
		override public function render():void
		{
			if (textBMD)
			{
				textBMD.dispose();
				textBMD = null;
			}
			
			FlowTextManager.renderTextVOLabel(this, textVO);
			renderAfterLabelRender();
			
			textDrawer.renderTextBMD(shape.graphics, textCanvas, textVO.scale * this.parent.scaleX);
		}
		
		
		/**
		 * 检测截图是否满足要求
		 */		
		public function checkTextBm(canvasScale:Number):void
		{
			textDrawer.checkTextBm(shape.graphics, textCanvas, textVO.scale * canvasScale);
		}
		
		/**
		 * 截图时不会恰好截取满足要求的尺寸，而是要多放大一些，这样截图计算就会少一点
		 * 
		 * 借以提升性能； 
		 */		
		private var scaleMultiple:Number = 2;
		
		/**
		 * 最大截图宽高乘积 
		 */		
		private var imgMaxSize:uint = 500000000;
		
		/**
		 */		
		private var textBMD:BitmapData;
		
		/**
		 */		
		public function afterReRender():void
		{
			textVO.width = textManager.compositionWidth;
			textVO.height = textManager.compositionHeight;
			
			renderAfterLabelRender();
			textDrawer.renderTextBMD(shape.graphics, textCanvas, textVO.scale * this.parent.scaleX);
		}
		
		/**
		 */
		public function get ifMutiLine():Boolean
		{
			return textVO.ifMutiLine;
		}
		
		/**
		 * @private
		 */
		public function set ifMutiLine(value:Boolean):void
		{
			textVO.ifMutiLine = value;
		}
		
		/**
		 * 
		 */		
		public function get fixWidth():Number
		{
			return vo.width;
		}
		
		/**
		 * @private
		 */
		public function set fixWidth(value:Number):void
		{
			vo.width = value;
		}
		
		/**
		 */		
		private function renderAfterLabelRender():void
		{
			textCanvas.x = - textVO.width / 2;
			textCanvas.y = - textVO.height / 2;
			
			super.render();
		}
		
		/**
		 * 初始化
		 */		
		override protected function preRender():void
		{
			super.preRender();
			
			textCanvas = new Sprite;
			addChild(textCanvas);
			
			textManager = new TextContainerManager(textCanvas);
			textManager.editingMode = EditingMode.READ_ONLY;
			
			textLayoutFormat = new TextLayoutFormat;
			textLayoutFormat.cffHinting = CFFHinting.NONE;
			textLayoutFormat.textAlign = TextAlign.LEFT;
			
			textManager.hostFormat = textLayoutFormat;
		}
		
		/**
		 */		
		private var _textManager:TextContainerManager;

		/**
		 */
		public function get textManager():TextContainerManager
		{
			return _textManager;
		}

		/**
		 * @private
		 */
		public function set textManager(value:TextContainerManager):void
		{
			_textManager = value;
		}

		/**
		 */		
		private var _textLyoutFormat:TextLayoutFormat;

		/**
		 */
		public function get textLayoutFormat():TextLayoutFormat
		{
			return _textLyoutFormat;
		}

		/**
		 * @private
		 */
		public function set textLayoutFormat(value:TextLayoutFormat):void
		{
			_textLyoutFormat = value;
		}
		
		/**
		 */		
		public function get textVO():TextVO
		{
			return vo as TextVO;
		}
		
		/**
		 */		
		public function clearText():void
		{
			textManager.setText("");
			textManager.updateContainer();
			this.shape.graphics.clear();
		}
		
		/**
		 */		
		private var textCanvas:Sprite = new Sprite;
	}
}