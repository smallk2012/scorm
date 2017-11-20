package cn.yingzaiqidian.scorm
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author cC Email:oC_Co@qq.com
	 */
	public class GlobalAs extends Object
	{
		public static const dispatcher:Sprite = new Sprite();
		public static var courseAr:Array = [];
		public static var configXml:XML = null;
		public static var skin:SkinLoader = null;
		public static var pIndex:int = 0;
		public static var studyIndex:int = 0;
		public static var catalogSize:int = 0;
		public static var score:Number = 0;
		public static var studyProgress:Number = 0;
		public static var swfVolume:Number = 0;
		public static var swf:McLoader;
		public static var playing:Boolean = true;
		public static var courseType:String = "local";
		public static var studyState:String = "incomplete";
		
		public static function log(msg, isObj = null):void {
			if (isObj) 
			{
				trace(JSON.stringify(msg));
			}
			else
			{
				trace(msg);
			}
		}
		public static function getClass(_str:String):*//库文件
		{
			var _class =Class(getDefinitionByName(_str));
			return new _class  ;
		}
		public static function XmltoObj(xml,ar)
		{
			var sub = xml.children();
			if (sub.length()>0)
			{
				for (var m = 0; m < sub.length(); m++)
				{
					var obj = {};
					var attrLen = sub[m].attributes().length();
					for(var n:int=0;n<attrLen;n++){  
						var attr:XML = sub[m].attributes()[n];  
						obj[attr.name().toString()] = attr.toString();  
					}
					ar.push(obj);
					XmltoObj(sub[m],ar);
				}
			}
		}
		public static function bl(value):Boolean
		{
			return value == "1" ? true : false;
		}
		public static function formatString(num:int):String {
			var str:String = num < 10 ? ("0" + num) : num.toString();
			return str;
		}
		public static function checkStudyState():void {
			if (GlobalAs.courseType == "scorm") {

				var curPro = Math.floor(GlobalAs.studyIndex * 1000 / GlobalAs.catalogSize)/10;
				var lessonProgress = curPro > GlobalAs.studyProgress ? curPro : GlobalAs.studyProgress;
				
				var lastNum = GlobalAs.studyIndex.toString();
				var studyTimeAr:Array = [];
				for (var m:int = 0; m < GlobalAs.courseAr.length; m++ ) {
					studyTimeAr.push(GlobalAs.courseAr[m].studyTime);
				}
				var suspendStr = studyTimeAr.toString();
				ScoFunction.sendProgressdata(lessonProgress.toString());
				//学习进度百分比;
				ScoFunction.sendLocation(lastNum);
				//最后记录;
				ScoFunction.sendSuspendData(suspendStr);
				//分数
				ScoFunction.sendScore(GlobalAs.score.toString());
				//每页进度;
				//如果所有文件都已经浏览，则提交平台课程学习完成状态

				if (GlobalAs.studyIndex == GlobalAs.catalogSize && GlobalAs.score >= parseInt(GlobalAs.configXml.@score) && GlobalAs.studyState != "completed")
				{
					ScoFunction.sendComplete();
					GlobalAs.studyState = "completed";
				}
			}
		}
	}
	
}