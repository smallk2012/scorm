package cn.yingzaiqidian.scorm 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author by cC Email:oC_Co@qq.com
	 */
	public class ToolMc extends MovieClip
	{
		private var muluBtn:MovieClip;
		private var playBtn:MovieClip;
		private var jinduBar:MovieClip;
		private var jinduBtn:MovieClip;
		private var jinduBtnTime:MovieClip;
		private var timeTip:MovieClip;
		private var pageTip:MovieClip;
		private var soundIcon:MovieClip;
		private var soundBar:MovieClip
		private var soundBtn:MovieClip;
		
		private var isdrag:Boolean = false;
		public var draging:Boolean = false;
		private var dragDelay:uint = 0;
		
		public function ToolMc() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			this.x = GlobalAs.configXml.ToolMc.@x || 0;
			this.y = GlobalAs.configXml.ToolMc.@y || 0;
			
			//创建工具栏背景
			var toolMc:MovieClip = GlobalAs.skin.getMc(Skin.TOOLMC);
			addChild(toolMc);
			
			muluBtn = GlobalAs.skin.getMc(Skin.MULUBTN);
			muluBtn.buttonMode = true;
			muluBtn.isIn = GlobalAs.bl(GlobalAs.configXml.MuluMc.@visible) ? true : false;
			muluBtn.visible = GlobalAs.bl(GlobalAs.configXml.ToolMc.MuluBtn.@visible);
			muluBtn.x = muluBtn.sx = GlobalAs.configXml.ToolMc.MuluBtn.@x || 0;
			muluBtn.y = muluBtn.sy = GlobalAs.configXml.ToolMc.MuluBtn.@y || 0;
			muluBtn.gotoAndStop(1);
			muluBtn.addEventListener(MouseEvent.CLICK, muluBtnClick);
			muluBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
			muluBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOut);
			addChild(muluBtn);
			
			var prevBtn:MovieClip = GlobalAs.skin.getMc(Skin.PREVBTN);
			prevBtn.buttonMode = true;
			prevBtn.visible = GlobalAs.bl(GlobalAs.configXml.ToolMc.PrevBtn.@visible);
			prevBtn.x = GlobalAs.configXml.ToolMc.PrevBtn.@x || 0;
			prevBtn.y = GlobalAs.configXml.ToolMc.PrevBtn.@y || 0;
			prevBtn.gotoAndStop(1);
			prevBtn.addEventListener(MouseEvent.CLICK, prevBtnClick);
			prevBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
			prevBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOut);
			addChild(prevBtn);
			
			playBtn = GlobalAs.skin.getMc(Skin.PLAYBTN);
			playBtn.buttonMode = true;
			playBtn.visible = GlobalAs.bl(GlobalAs.configXml.ToolMc.PlayBtn.@visible);
			playBtn.x = GlobalAs.configXml.ToolMc.PlayBtn.@x || 0;
			playBtn.y = GlobalAs.configXml.ToolMc.PlayBtn.@y || 0;
			playBtn.gotoAndStop(1);
			playBtn.state = 1;
			playBtn.addEventListener(MouseEvent.CLICK, playBtnClick);
			playBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOverFour);
			playBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutFour);
			addChild(playBtn);
			
			var nextBtn:MovieClip = GlobalAs.skin.getMc(Skin.NEXTBTN);
			nextBtn.buttonMode = true;
			nextBtn.visible = GlobalAs.bl(GlobalAs.configXml.ToolMc.NextBtn.@visible);
			nextBtn.x = GlobalAs.configXml.ToolMc.NextBtn.@x || 0;
			nextBtn.y = GlobalAs.configXml.ToolMc.NextBtn.@y || 0;
			nextBtn.gotoAndStop(1);
			nextBtn.addEventListener(MouseEvent.CLICK, nextBtnClick);
			nextBtn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
			nextBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOut);
			addChild(nextBtn);
			
			var jinduMc:MovieClip = GlobalAs.skin.getMc(Skin.JINDUMC);
			jinduMc.visible = GlobalAs.bl(GlobalAs.configXml.ToolMc.JinduMc.@visible);
			jinduMc.x = GlobalAs.configXml.ToolMc.JinduMc.@x || 0;
			jinduMc.y = GlobalAs.configXml.ToolMc.JinduMc.@y || 0;
			addChild(jinduMc);
			jinduMc.addEventListener(MouseEvent.MOUSE_WHEEL, jinduWheel);
			
			var jinduBarBg:MovieClip = GlobalAs.skin.getMc(Skin.JINDUBARBG);
			jinduBarBg.mouseChildren = false;
			jinduBarBg.x = GlobalAs.configXml.ToolMc.JinduMc.JinduBarBg.@x || 0;
			jinduBarBg.y = GlobalAs.configXml.ToolMc.JinduMc.JinduBarBg.@y || 0;
			jinduMc.addChild(jinduBarBg);
			
			jinduBar = GlobalAs.skin.getMc(Skin.JINDUBAR);
			jinduBar.mouseChildren = false;
			jinduBar.mouseEnabled = false;
			jinduBar.x = GlobalAs.configXml.ToolMc.JinduMc.JinduBar.@x || 0;
			jinduBar.y = GlobalAs.configXml.ToolMc.JinduMc.JinduBar.@y || 0;
			jinduMc.addChild(jinduBar);
			jinduBar.contW = jinduBar.width;
			jinduBar.width = 1;
			
			jinduBtn = GlobalAs.skin.getMc(Skin.JINDUBTN);
			jinduBtn.buttonMode = true;
			jinduBtn.mouseChildren = false;
			jinduBtn.x = jinduBarBg.x;
			jinduBtn.y = jinduBarBg.y;
			jinduBtn.contW = jinduBtn.width;
			jinduMc.addChild(jinduBtn);
			jinduBtn.addEventListener(MouseEvent.MOUSE_OVER, jinduBtnOver);
			jinduBtn.addEventListener(MouseEvent.MOUSE_OUT, jinduBtnOut);
			jinduBtn.addEventListener(MouseEvent.MOUSE_DOWN, jinduBtnDown);
			
			jinduBtnTime = GlobalAs.skin.getMc(Skin.JINDUBTNTIME);
			jinduBtnTime.mouseChildren = false;
			jinduBtnTime.mouseEnabled = false;
			jinduBtnTime.x = GlobalAs.configXml.ToolMc.JinduMc.JinduBtn.JinduBtnTime.@x || 0;
			jinduBtnTime.y = GlobalAs.configXml.ToolMc.JinduMc.JinduBtn.JinduBtnTime.@y || 0;
			jinduBtn.addChild(jinduBtnTime);
			var btnTime:XML = XML(GlobalAs.configXml.ToolMc.JinduMc.JinduBtn.JinduBtnTime);
			jinduBtnTime.visible = btnTime.@fixed == "1" && btnTime.@visible == "1" ? true : false;
			
			
			timeTip = GlobalAs.skin.getMc(Skin.TIMETIP);
			timeTip.mouseChildren = false;
			timeTip.mouseEnabled = false;
			timeTip.visible = GlobalAs.bl(GlobalAs.configXml.ToolMc.TimeTip.@visible);
			timeTip.x = GlobalAs.configXml.ToolMc.TimeTip.@x || 0;
			timeTip.y = GlobalAs.configXml.ToolMc.TimeTip.@y || 0;
			addChild(timeTip);
			
			pageTip = GlobalAs.skin.getMc(Skin.PAGETIP);
			pageTip.mouseChildren = false;
			pageTip.mouseEnabled = false;
			pageTip.visible = GlobalAs.bl(GlobalAs.configXml.ToolMc.PageTip.@visible);
			pageTip.x = GlobalAs.configXml.ToolMc.PageTip.@x || 0;
			pageTip.y = GlobalAs.configXml.ToolMc.PageTip.@y || 0;
			addChild(pageTip);
			
			var soundMc:MovieClip = GlobalAs.skin.getMc(Skin.SOUNDMC);
			soundMc.visible = GlobalAs.bl(GlobalAs.configXml.ToolMc.SoundMc.@visible);
			soundMc.x = GlobalAs.configXml.ToolMc.SoundMc.@x || 0;
			soundMc.y = GlobalAs.configXml.ToolMc.SoundMc.@y || 0;
			addChild(soundMc);
			soundMc.addEventListener(MouseEvent.MOUSE_WHEEL, soundWheel);
			
			soundIcon = GlobalAs.skin.getMc(Skin.SOUNDICON);
			soundIcon.buttonMode = true;
			soundIcon.x = GlobalAs.configXml.ToolMc.SoundMc.SoundIcon.@x || 0;
			soundIcon.y = GlobalAs.configXml.ToolMc.SoundMc.SoundIcon.@y || 0;
			soundIcon.state = parseFloat(GlobalAs.configXml.ToolMc.SoundMc.@volume) == 0 ? 2 : 1;
			soundIcon.isIn = false;
			soundIcon.gotoAndStop(parseFloat(GlobalAs.configXml.ToolMc.SoundMc.@volume) == 0 ? 3 : 1);
			soundIcon.addEventListener(MouseEvent.CLICK, soundIconClick);
			soundIcon.addEventListener(MouseEvent.MOUSE_OVER, btnOverFour);
			soundIcon.addEventListener(MouseEvent.MOUSE_OUT,btnOutFour);
			soundMc.addChild(soundIcon);
			
			soundBar = GlobalAs.skin.getMc(Skin.SOUNDBAR);
			soundBar.x = GlobalAs.configXml.ToolMc.SoundMc.SoundBar.@x || 0;
			soundBar.y = GlobalAs.configXml.ToolMc.SoundMc.SoundBar.@y || 0;
			soundMc.addChild(soundBar);
			
			soundBtn = GlobalAs.skin.getMc(Skin.SOUNDBTN);
			soundBtn.buttonMode = true;
			soundMc.addChild(soundBtn);
			if (GlobalAs.configXml.ToolMc.SoundMc.@direction == "h") {
				soundBtn.x = soundBar.x + soundBar.width * parseFloat(GlobalAs.configXml.ToolMc.SoundMc.@volume);
				soundBtn.y = soundBar.y;
			}
			else {
				soundBtn.x = soundBar.x;
				soundBtn.y = soundBar.y + soundBar.height - soundBtn.height;
			}
			
			soundBtn.addEventListener(MouseEvent.MOUSE_DOWN, soundBtnDown);
			
			var bsoundMc:MovieClip = GlobalAs.skin.getMc(Skin.BSOUNDMC);
			bsoundMc.buttonMode = true;
			bsoundMc.visible = GlobalAs.bl(GlobalAs.configXml.ToolMc.BsoundMc.@visible);
			bsoundMc.x = GlobalAs.configXml.ToolMc.BsoundMc.@x || 0;
			bsoundMc.y = GlobalAs.configXml.ToolMc.BsoundMc.@y || 0;
			bsoundMc.state = GlobalAs.bl(GlobalAs.configXml.ToolMc.BsoundMc.@initsound) ? 1 : 2;
			bsoundMc.gotoAndStop(GlobalAs.bl(GlobalAs.configXml.ToolMc.BsoundMc.@initsound) ? 1 : 3);
			bsoundMc.addEventListener(MouseEvent.CLICK, bsoundMcClick);
			bsoundMc.addEventListener(MouseEvent.MOUSE_OVER, btnOverFour);
			bsoundMc.addEventListener(MouseEvent.MOUSE_OUT,btnOutFour);
			addChild(bsoundMc);
		}
		private function btnOver(e:MouseEvent):void {
			e.currentTarget.gotoAndStop(2);
		}
		private function btnOut(e:MouseEvent):void {
			e.currentTarget.gotoAndStop(1);
		}
		private function btnOverFour(e:MouseEvent):void {
			e.currentTarget.isIn = true;
			if (e.currentTarget.state == 2) {
				e.currentTarget.gotoAndStop(4);
			}
			else {
				e.currentTarget.gotoAndStop(2);
			}
		}
		private function btnOutFour(e:MouseEvent):void {
			e.currentTarget.isIn = false;
			if (e.currentTarget.state == 2) {
				e.currentTarget.gotoAndStop(3);
			}
			else {
				e.currentTarget.gotoAndStop(1);
			}
		}
		private function jinduBtnOver(e:MouseEvent):void {
			if (GlobalAs.bl(GlobalAs.configXml.ToolMc.JinduMc.JinduBtn.JinduBtnTime.@visible)) {
				jinduBtnTime.visible = true;
			}
		}
		private function jinduBtnOut(e:MouseEvent):void {
			var btnTime:XML = XML(GlobalAs.configXml.ToolMc.JinduMc.JinduBtn.JinduBtnTime);
			if (GlobalAs.bl(btnTime.@visible) && GlobalAs.bl(btnTime.@fixed)) {
				jinduBtnTime.visible = true;
			}
			else {
				jinduBtnTime.visible = false;
			}
		}
		private function muluBtnClick(e:MouseEvent):void {
			e.currentTarget.isIn = e.currentTarget.isIn ? false : true;
			GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.MULU, { isIn:e.currentTarget.isIn } ));
		}
		private function prevBtnClick(e:MouseEvent):void {
			if (GlobalAs.pIndex > 0) {
				var catalog = GlobalAs.courseAr[GlobalAs.pIndex - 1].catalog;
				if (catalog != "0") {
					GlobalAs.pIndex--;
					GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.LOAD_PAGE, { pIndex:GlobalAs.pIndex } ));
				}
			}
		}
		
		private function playBtnClick(e:MouseEvent):void {
			if (e.currentTarget.state == 2) {
				e.currentTarget.state = 1;
				e.currentTarget.gotoAndStop(2);
			}
			else {
				e.currentTarget.state = 2;
				e.currentTarget.gotoAndStop(4);
			}
			GlobalAs.playing = e.currentTarget.state == 1 ? true : false;
			GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.JINDUBTN));
		}
		private function nextBtnClick(e:MouseEvent):void {
			GlobalAs.log(GlobalAs.courseAr[GlobalAs.pIndex].studyTime);
			if (GlobalAs.pIndex < GlobalAs.courseAr.length - 1) {
				if (GlobalAs.pIndex <= GlobalAs.studyIndex  && GlobalAs.courseAr[GlobalAs.pIndex].studyTime == 100) {
					GlobalAs.pIndex++;
					GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.LOAD_PAGE, { pIndex:GlobalAs.pIndex } ));
				}
				else {
					if (GlobalAs.configXml.MuluMc.@clicknext == "1") {
						GlobalAs.pIndex++;
						GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.LOAD_PAGE, { pIndex:GlobalAs.pIndex } ));
					}
					else {
						GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.ALERT, { msg: GlobalAs.configXml.Alert.NoLearn } ));
					}
				}
			}
		}
		private function jinduBtnDown(e:MouseEvent):void {
			if (isdrag) {
				draging = true;
				jinduBtn.startDrag(false, new Rectangle(jinduBar.x, jinduBar.y, jinduBar.contW - jinduBtn.contW, 0));
				jinduBtn.addEventListener(MouseEvent.MOUSE_UP, jinduBtnUp);
				stage.addEventListener(MouseEvent.MOUSE_UP, jinduBtnUp);
				stage.addEventListener(Event.ENTER_FRAME,jinduBtnFrame);
			}
		}
		private function jinduBtnUp(e:MouseEvent):void {
			draging = false;
			jinduBtn.stopDrag();
			jinduBtn.removeEventListener(MouseEvent.MOUSE_UP, jinduBtnUp);
			stage.removeEventListener(MouseEvent.MOUSE_UP, jinduBtnUp);
			stage.removeEventListener(Event.ENTER_FRAME, jinduBtnFrame);
			GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.JINDUBTN));
		}
		private function jinduBtnFrame(e:Event = null):void {
			jinduBar.width = jinduBtn.x - jinduBar.x;
		}
		private function jinduWheel(e:MouseEvent):void {
			if (isdrag) {
				draging = true;
				if (dragDelay) {
					clearTimeout(dragDelay);
					dragDelay = 0;
				}
				dragDelay = setTimeout(function() {
					draging = false;
					GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.JINDUBTN));
				},500);
				if (e.delta < 0) {
					jinduBtn.x += 2;
				}
				else 
				{
					jinduBtn.x -= 2;
				}
				if (jinduBtn.x < jinduBar.x) {
					jinduBtn.x = jinduBar.x;
				}
				else if (jinduBtn.x > jinduBar.x + jinduBar.contW - jinduBtn.contW) {
					jinduBtn.x = jinduBar.x + jinduBar.contW - jinduBtn.contW;
				}
				jinduBtnFrame();
				
			}
		}
		
		private function soundIconClick(e:MouseEvent):void {
			if (e.currentTarget.state == 2) {
				e.currentTarget.state = 1;
				e.currentTarget.gotoAndStop(2);
				soundBtn.x = soundBar.x + soundBar.width * parseFloat(GlobalAs.configXml.ToolMc.SoundMc.@volume);
			}
			else {
				e.currentTarget.state = 2;
				e.currentTarget.gotoAndStop(4);
				soundBtn.x = soundBar.x;
			}
			if (GlobalAs.swf) {
				GlobalAs.swfVolume = (soundBtn.x - soundBar.x) / (soundBar.width - soundBtn.width);
				GlobalAs.swf.setVolume();
			}
		}
		
		private function soundBtnDown(e:MouseEvent):void {
			soundBtn.startDrag(false, new Rectangle(soundBar.x, soundBar.y, soundBar.width - soundBtn.width, 0));
			soundBtn.addEventListener(MouseEvent.MOUSE_UP, soundBtnUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, soundBtnUp);
			stage.addEventListener(Event.ENTER_FRAME, soundBtnFrame);
		}
		private function soundBtnUp(e:MouseEvent):void {
			soundBtn.stopDrag();
			soundBtn.removeEventListener(MouseEvent.MOUSE_UP, soundBtnUp);
			stage.removeEventListener(MouseEvent.MOUSE_UP, soundBtnUp);
			stage.removeEventListener(Event.ENTER_FRAME, soundBtnFrame);
		}
		private function soundBtnFrame(e:Event = null):void {
			if (soundBtn.x <= soundBar.x) {
				soundIcon.state = 2;
				soundIcon.gotoAndStop(soundIcon.isIn ? 4 : 3);
			}
			else {
				soundIcon.state = 1;
				soundIcon.gotoAndStop(soundIcon.isIn ? 2 : 1);
			}
			if (GlobalAs.swf) {
				GlobalAs.swfVolume = (soundBtn.x - soundBar.x) / (soundBar.width - soundBtn.width);
				GlobalAs.swf.setVolume();
			}
		}
		private function soundWheel(e:MouseEvent):void {
			if (e.delta < 0) {
				soundBtn.x += 1;
			}
			else 
			{
				soundBtn.x -= 1;
			}
			if (soundBtn.x <= soundBar.x) {
				soundBtn.x = soundBar.x;
			}
			else if (soundBtn.x > soundBar.x + soundBar.width - soundBtn.width) {
				soundBtn.x = soundBar.x + soundBar.width - soundBtn.width;
			}
			soundBtnFrame();
		}
		private function bsoundMcClick(e:MouseEvent):void {
			if (e.currentTarget.state == 2) {
				e.currentTarget.state = 1;
				e.currentTarget.gotoAndStop(2);
				GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.BSOUND,{play: true}));
			}
			else {
				e.currentTarget.state = 2;
				e.currentTarget.gotoAndStop(4);
				GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.BSOUND,{play: false}));
			}
		}
		public function stateFun():void {
			GlobalAs.log(GlobalAs.courseAr[GlobalAs.pIndex], true);
			//-1不能拖拽无进度0不能拖拽1可以拖拽2学完可拖拽
			var str:String = GlobalAs.courseAr[GlobalAs.pIndex].isdrag;
			switch(str) {
				case "-1":
					isdrag = false;
				break;
				case "0":
					isdrag = false;
				break;
				case "1":
					isdrag = true;
				break;
				case "2":
					isdrag = GlobalAs.courseAr[GlobalAs.pIndex].studyTime == 100 ? true : false;
				break;
			}

			jinduBtn.buttonMode = isdrag;
			this.visible = GlobalAs.bl(GlobalAs.courseAr[GlobalAs.pIndex].showtoolbar);
			
			//设置进度条
			jinduBtn.x = jinduBar.x;
			jinduBtnFrame();
			//播放按钮
			playBtn.state = 1;
			playBtn.gotoAndStop(1);
			GlobalAs.playing = true;
			//页码
			if (GlobalAs.courseAr[GlobalAs.pIndex].hasOwnProperty("cataloIndex")) {
				pageTip.txt.text = (GlobalAs.courseAr[GlobalAs.pIndex].cataloIndex) + "/" + GlobalAs.catalogSize;
			}
			else {
				pageTip.txt.text = "-- / --";
			}
			if (GlobalAs.courseAr[GlobalAs.pIndex].isdrag == "-1" || GlobalAs.swf == null) {
				jinduBtnTime.txt.text = "-- : --";
				timeTip.txt.text = "-- : --";
			}
			else {
				jinduBtnTime.txt.text = "00:00";
				timeTip.txt.text = "00:00";
			}
		}
		public function setJindu(obj:Object):void {
			var m:int = Math.floor(obj.cframe / 60);
			var s:int = Math.floor(obj.cframe % 60);
			
			var mm:int = Math.floor(obj.tframe / 60);
			var ss:int = Math.floor(obj.tframe % 60);
			if (GlobalAs.courseAr[GlobalAs.pIndex].isdrag != "-1") {
				jinduBtnTime.txt.text = GlobalAs.formatString(m) + ":" + GlobalAs.formatString(s);
				timeTip.txt.text = jinduBtnTime.txt.text + "/" + GlobalAs.formatString(mm) + ":" + GlobalAs.formatString(ss);
			
				//进度条
				if (!draging) {
					jinduBtn.x = jinduBar.x + (jinduBar.contW - jinduBtn.contW) * obj.bfb;
					jinduBtnFrame();
				}
			}
		}
		public function setPlayBtn(bl:Boolean) {
			if (bl) {
				playBtn.state = 1;
				playBtn.gotoAndStop(1);
			}
			else {
				playBtn.state = 2;
				playBtn.gotoAndStop(3);
			}
		}
		public function getBfb():Number {
			var bfb:Number = (jinduBtn.x - jinduBar.x) / (jinduBar.contW - jinduBtn.contW);
			return bfb;
		}
	}

}