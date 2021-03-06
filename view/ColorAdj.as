﻿package view {
	import flash.display.Sprite;
	import fl.motion.AdjustColor;
	import flash.filters.ColorMatrixFilter;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	import fl.controls.SliderDirection;//滑动条的方向
    import flash.display.Bitmap;
	import fl.controls.Button;
	import flash.events.MouseEvent;
    import flash.text.*;
	
	public class ColorAdj extends Sprite
	{
		private var color:AdjustColor;
		public var filter:ColorMatrixFilter;		
		private var brightSL:Slider, contSL:Slider, hueSL:Slider, satSL:Slider;
		private var images:Array;
		
		public function ColorAdj() {
					
			addChild(newField("亮　度：", 0, -5));
			addChild(newField("对比度：", 0, 20));
			addChild(newField("饱合度：", 0, 45));
			//addChild(newField("色　相：", 0, 70));

			brightSL = newSlider(55, 0);
			contSL = newSlider(55, 25);
			satSL = newSlider(55, 50);
			hueSL = newSlider(55, 75);
			
			addChild(brightSL);
			addChild(contSL);
			addChild(satSL);
			//addChild(hueSL); 禁用色相
						
			btnReset = new Button();
			btnReset.x = 35;
			btnReset.y = 75;
			btnReset.label = "重置";
			btnReset.setStyle("textFormat", new TextFormat("宋体", 12, 0xDDDDDD));
			addChild(btnReset);
			
			color = new AdjustColor();
			filter = new ColorMatrixFilter(color.CalculateFinalFlatArray());
			
			sliderInit();
			colorInit();
			addListeners();
		}
		
		private function newSlider(x:Number, y:Number):Slider{
			var slider = new Slider();
			with(slider){
				direction = SliderDirection.HORIZONTAL;//水平的，还是垂直方向的拖动条，默认是水平的
				liveDragging = true;//true：拖动的时候，允许change事件随滑块一起变化。false：鼠标拖完，松开滑块后，才执行change事件。
				maximum = 100;//最大值
				minimum = 0;//最小值
				snapInterval = 1;//一次拖动变化的数值
				tickInterval = 10;//把拖动条分成一格一格的，一格的刻度是多少
				width = 100;
			}
			slider.x = x;
			slider.y = y;
			return slider;
		}
		
		private function newField(text:String, x:Number, y:Number):TextField{
			var label:TextField = new TextField();
			label.text = text;
			label.x = x;
			label.y = y;
			label.height = 40;
			label.multiline = true;
			label.selectable = false;
			var txtFormat = new TextFormat("宋体", 12, 0xDDDDDD);
			txtFormat.align = TextFormatAlign.LEFT;
            label.setTextFormat(txtFormat);
			return label;
		}
		
		private function sliderInit():void{
			brightSL.value = 50;
			contSL.value = 50;
			hueSL.value = 50;
			satSL.value = 50;
		}
		
		private function colorInit():void{
			with(color){
				brightness = 1;
				contrast = 1;
				hue = 1;
				saturation = 1;
			}
		}
		
		public function setImages(images:Array){
			this.images = images;
		}
		
		private final function addListeners():void
		{
			brightSL.addEventListener(SliderEvent.CHANGE, adjustBrightness);
			contSL.addEventListener(SliderEvent.CHANGE, adjustContrast);
			hueSL.addEventListener(SliderEvent.CHANGE, adjustHue);
			satSL.addEventListener(SliderEvent.CHANGE, adjustSaturation);
			
			btnReset.addEventListener(MouseEvent.CLICK, doReset);
		}
		
		private final function adjustBrightness(e:SliderEvent):void
		{
			color.brightness = e.target.value - 50;
			update();
		}
		
		private final function adjustContrast(e:SliderEvent):void
		{
			color.contrast = e.target.value - 50;
			update();
		}
		
		private final function adjustHue(e:SliderEvent):void
		{
			color.hue = e.target.value - 50;
			update();
		}
		
		private final function adjustSaturation(e:SliderEvent):void
		{
			color.saturation = e.target.value - 50;
			update();
		}
		
		private final function update():void
		{
			filter = new ColorMatrixFilter(color.CalculateFinalFlatArray());
			for(var i = 0; i < images.length; i ++)
				images[i].filters = [filter];
		}
		
		private final function doReset(event:MouseEvent):void{
			sliderInit();
			colorInit();
			update();
		}
	}
}