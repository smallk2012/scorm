package cn.yingzaiqidian.scorm 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author by cC Email:oC_Co@qq.com
	 */
	public class MuluMc extends MovieClip
	{
		private var muluMcNavArea:MovieClip;
		private var muluMcScrollBar:MovieClip;
		private var muluMcScrollBarBg:MovieClip;
		private var rollSpeed:int = 10;//每次滚动速度
		private var navAr:Array = [];
		private var isIn:Boolean = false;
		public function MuluMc() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point

			//创建目录背景
			var muluMc:MovieClip = GlobalAs.skin.getMc(Skin.MULUMC);
			addChild(muluMc);
			
			//设置目录位置
			if (GlobalAs.bl(GlobalAs.configXml.MuluMc.@visible)) {
				this.x = 0;
			}
			else {
				this.x = - muluMc.width;
			}
			
			this.y = GlobalAs.configXml.MuluMc.@y || 0;
			
			
			//创建菜单区域遮罩
			var muluMcNavAreaMask:MovieClip = GlobalAs.skin.getMc(Skin.MULUMCNAVAREABG);
			muluMcNavAreaMask.x = GlobalAs.configXml.MuluMc.MuluMcNavAreaBg.@x || 0;
			muluMcNavAreaMask.y = GlobalAs.configXml.MuluMc.MuluMcNavAreaBg.@y || 0;
			addChild(muluMcNavAreaMask);
			//创建菜单区域背景
			var muluMcNavAreaBg:MovieClip = GlobalAs.skin.getMc(Skin.MULUMCNAVAREABG);
			muluMcNavAreaBg.x = muluMcNavAreaMask.x;
			muluMcNavAreaBg.y = muluMcNavAreaMask.y;
			muluMcNavAreaBg.mask = muluMcNavAreaMask;
			addChild(muluMcNavAreaBg);
			//创建菜单区域
			muluMcNavArea = new MovieClip();
			muluMcNavArea.maskH = muluMcNavAreaMask.height;
			muluMcNavAreaBg.addChild(muluMcNavArea);
			//创建菜单
			var stratY:Number = 0;
			var cataloIndex:int = 0;
			for (var m:int = 0; m < GlobalAs.courseAr.length; m++ ) {
				var obj:Object = GlobalAs.courseAr[m];
				obj.studyTime = 0;
				var nav:MovieClip = GlobalAs.skin.getMc(Skin.NAVSKIN + obj.skin);
				nav.buttonMode = true;
				nav.mouseChildren = false;
				nav.y = stratY;
				nav.gotoAndStop(1);
				nav.txt.text = obj.lable;
				muluMcNavArea.addChild(nav);
				nav.playing = false;
				nav.pIndex = m;
				navAr.push(nav);
				nav.addEventListener(MouseEvent.MOUSE_OVER, navOver);
				nav.addEventListener(MouseEvent.MOUSE_OUT, navOut);
				nav.addEventListener(MouseEvent.CLICK, navClick);
				if (obj.catalog != '0') {
					cataloIndex++;
					obj.cataloIndex = cataloIndex;
					stratY = nav.y + nav.height;
				}
				else {
					nav.visible = false;
				}
			}
			GlobalAs.catalogSize = cataloIndex;
			muluMcNavArea.contH = stratY;
			//创建滚动条背景
			muluMcScrollBarBg = GlobalAs.skin.getMc(Skin.MULUMCSCROLLBARBG);
			muluMcScrollBarBg.x = GlobalAs.configXml.MuluMc.MuluMcScrollBarBg.@x || 0;
			muluMcScrollBarBg.y = GlobalAs.configXml.MuluMc.MuluMcScrollBarBg.@y || 0;
			addChild(muluMcScrollBarBg);
			//创建滚动条
			muluMcScrollBar = GlobalAs.skin.getMc(Skin.MULUMCSCROLLBAR);
			muluMcScrollBar.mouseChildren = false;
			muluMcScrollBar.buttonMode = true;
			muluMcScrollBar.x = muluMcScrollBarBg.x;
			muluMcScrollBar.y = muluMcScrollBarBg.y;
			addChild(muluMcScrollBar);
			
			muluMcScrollBar.addEventListener(MouseEvent.MOUSE_DOWN, scrollBarDown);
			//重置滚动条
			if (stratY <= muluMcNavAreaMask.height) {
				muluMcScrollBarBg.visible = false;
				muluMcScrollBar.visible = false;
			}
			else {
				this.addEventListener(MouseEvent.MOUSE_WHEEL, muluWheel);
				//每次滚动rollSpeed需rollNum次
				var rollNum:Number = Math.ceil((stratY - muluMcNavAreaMask.height) / rollSpeed);
				//滚动区域(=可滚最大次数)
				var rollH:Number = muluMcScrollBarBg.height - muluMcScrollBar.height;
				if (rollNum <= rollH) {
					muluMcScrollBar.height = muluMcScrollBarBg.height - rollNum;
				}
				else
				{
					//实际滚动次数大于可滚最大次数，重新计算滚动速度
					rollSpeed = (rollNum * rollSpeed)  / rollH;
				}
			}
			
		}
		private function scrollBarDown(e:MouseEvent):void {
			muluMcScrollBar.startDrag(false,new Rectangle(muluMcScrollBarBg.x,muluMcScrollBarBg.y,0, muluMcScrollBarBg.height - muluMcScrollBar.height));
			muluMcScrollBar.addEventListener(MouseEvent.MOUSE_UP, scrollBarUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, scrollBarUp);
			stage.addEventListener(Event.ENTER_FRAME,scrollBarFrame);
		}
		private function scrollBarUp(e:MouseEvent):void {
			muluMcScrollBar.stopDrag();
			muluMcScrollBar.removeEventListener(MouseEvent.MOUSE_UP, scrollBarUp);
			stage.removeEventListener(MouseEvent.MOUSE_UP, scrollBarUp);
			stage.removeEventListener(Event.ENTER_FRAME,scrollBarFrame);
		}
		private function scrollBarFrame(e:Event = null):void {
			var rollStep:Number = muluMcScrollBar.y - muluMcScrollBarBg.y;
			muluMcNavArea.y = 0 - rollStep * rollSpeed;
			if (muluMcNavArea.y < muluMcNavArea.maskH - muluMcNavArea.contH) {
				muluMcNavArea.y = muluMcNavArea.maskH - muluMcNavArea.contH;
			}
		}
		private function muluWheel(e:MouseEvent):void {
			if (e.delta < 0) {
				muluMcScrollBar.y += 1;
			}
			else 
			{
				muluMcScrollBar.y -= 1;
			}
			if (muluMcScrollBar.y < muluMcScrollBarBg.y) {
				muluMcScrollBar.y = muluMcScrollBarBg.y;
			}
			else if (muluMcScrollBar.y > muluMcScrollBarBg.y + muluMcScrollBarBg.height - muluMcScrollBar.height) {
				muluMcScrollBar.y = muluMcScrollBarBg.y + muluMcScrollBarBg.height - muluMcScrollBar.height;
			}
			scrollBarFrame();
		}
		private function navOver(e:MouseEvent):void {
			e.currentTarget.gotoAndStop(2);
		}
		private function navOut(e:MouseEvent):void {
			if (!e.currentTarget.playing) {
				e.currentTarget.gotoAndStop(1);
			}
		}
		
		private function navClick(e:MouseEvent):void {
			if (!e.currentTarget.playing) {
				if (e.currentTarget.pIndex == 0 || (e.currentTarget.pIndex > 0 && GlobalAs.courseAr[e.currentTarget.pIndex - 1].studyTime == 100)) {
					GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.LOAD_PAGE, { pIndex:e.currentTarget.pIndex } ));
				}
				else {
					if (GlobalAs.configXml.MuluMc.@clicknext == "1") {
						GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.LOAD_PAGE, { pIndex:e.currentTarget.pIndex } ));
					}
					else {
						GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.ALERT, { msg: GlobalAs.configXml.Alert.NoLearn } ));
					}
				}
			}
		}
		public function changeActive(pIndex:int):void {
			for (var m:int = 0; m < navAr.length; m++ ) {
				if (pIndex == m) {
					navAr[m].playing = true;
					navAr[m].gotoAndStop(2);
					if (muluMcNavArea.contH > muluMcNavArea.maskH) 
					{
						var mH:int = 0;
						if (navAr[m].y + muluMcNavArea.y <= 0) {
							mH = m > 0 ? navAr[m - 1].height : 0;
							muluMcNavArea.y += Math.abs((navAr[m].y + muluMcNavArea.y)) + mH; 
							muluMcNavArea.y = muluMcNavArea.y > 0 ? 0 : muluMcNavArea.y;
						}
						else {
							mH = m < navAr.length - 1 ? navAr[m + 1].height : 0;
							if (navAr[m].y + muluMcNavArea.y + navAr[m].height >= muluMcNavArea.maskH) {
								muluMcNavArea.y -= (navAr[m].y + muluMcNavArea.y + navAr[m].height - muluMcNavArea.maskH) + mH; 
								muluMcNavArea.y = muluMcNavArea.y < muluMcNavArea.maskH - muluMcNavArea.contH ? muluMcNavArea.maskH - muluMcNavArea.contH : muluMcNavArea.y;
							}
						}

						var rollNum:int = Math.ceil(Math.abs(muluMcNavArea.y) / rollSpeed);
						var rollH:Number = muluMcScrollBarBg.height - muluMcScrollBar.height;
						if (rollNum > rollH) {
							rollNum = rollH;
						}
					
						muluMcScrollBar.y = muluMcScrollBarBg.y + rollNum;
						scrollBarFrame();
					}
				}
				else {
					navAr[m].playing = false;
					navAr[m].gotoAndStop(1);
				}
			}
		}
	}

}