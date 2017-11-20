package cn.yingzaiqidian.scorm
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author CC E-mail:oC_Co@qq.com
	 */
	public class MyEvent extends Event
	{
		public static const LOAD_PAGE:String = "load_page";
		public static const ALERT:String = "alert";
		public static const MULU:String = "MuLu";
		public static const BSOUND:String = "bsound";
		public static const JINDUBTN:String = "jindubtn";
		
		private var _object:Object;
		////////////////////////////////////////////////////////////////////
		
		public function MyEvent(type:String, object:Object=null):void
		{
			super(type);
			_object = object;
		}
		public function get param():Object
		{
			return _object;
		}
	}
	
}