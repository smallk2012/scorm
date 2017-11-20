package cn.yingzaiqidian.scorm{
	import flash.external.ExternalInterface;
	
	public class ScoFunction{		
		
		//发送成绩
		public static function sendScore(data:String){
			try{
				ExternalInterface.call("setScore",data);
			}catch(e:Error){
			}
		}
		
		//发送当前位置
		public static function sendLocation(data:String){
			try{
				ExternalInterface.call("setLocation",data);
			}catch(e:Error){
			}
		}
		
		//发送中断数据
		public static function sendSuspendData(data:String){
			try{
				ExternalInterface.call("setSuspenddata",data);
			}catch(e:Error){
			}
		}
			
		//发送进度
		public static function sendProgressdata(data:String){
			try{
				ExternalInterface.call("setprogressdata",data);
			}catch(e:Error){
			}
		}
		
		//发送进度
		public static function sendComplete(){
			try{
				ExternalInterface.call("SetComplete");
			}catch(e:Error){
			}
		}
		
		//获得数据
		public static function getInfo(fName:String):String{
			var str:String = "";
			try{
				str = ExternalInterface.call(fName);
				
			}catch(e:Error){
			}
			return str;
		}
	}
}