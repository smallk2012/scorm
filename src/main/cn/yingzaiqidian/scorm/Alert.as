package cn.yingzaiqidian.scorm 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author by cC Email:oC_Co@qq.com
	 */
	public class Alert extends MovieClip
	{
		var alert:MovieClip;
		public function Alert(msg:String) 
		{
			alert = GlobalAs.skin.getMc(Skin.ALERT);
			addChild(alert);
			alert.btn.buttonMode = true;
			alert.txt.text = msg;
			alert.btn.addEventListener(MouseEvent.CLICK,btnClick);
		}
		private function btnClick(e:MouseEvent):void {
			alert.btn.removeEventListener(MouseEvent.CLICK,btnClick);
			var p = this.parent;
			p.removeChild(this);
		}
	}

}