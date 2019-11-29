using Toybox.Communications as Comm;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class CryptoPrice {	//Data of top 10 market cap coins
	var curSpotPrice = new Ticker(); //Current $USD price of top 10
	var curFuturePrice = new Ticker(); //Current €EUR price of top 10
	var curSwapPrice = new Ticker(); //Currencies in top 10
}

class Ticker {
	var last = 0.0;
	var low = 0.0;
	var high = 0.0;
	var open = 0.0;
}

//class PriceModel {
//	var cp = null;
//	//CoinMarketCap JSON API
//	
//	
//	hidden var notify;
//	
//  	function initialize(handler)	{
//  		notify = handler;
//        makePriceRequests();    				 
//    }
//    
//    function makePriceRequests() {
//		//Check if Communications is allowed for Widget usage
//			if (Toybox has :Communications) {
//	//			cp = null;
//				if(isConnectionAvailable()){
//					// Get current price and coin symbol from API
//					Comm.makeWebRequest(cryptoSpotPriceURL,
//				         				 {}, 
//				         				 {}, 
//				         				 method(:onReceiveData));
//				    Comm.makeWebRequest(cryptoFuturePriceURL,
//				         				 {}, 
//				         				 {}, 
//				         				 method(:onReceiveData));
//				    Comm.makeWebRequest(cryptoSwapPriceURL,
//				         				 {}, 
//				         				 {}, 
//				         				 method(:onReceiveData));
//				}else{
//					notify.invoke(0.0, "ERROR");
//				}	
//			}
//		
//    }
//
//	function onReceiveData(responseCode, data) {
//        if(responseCode == 200) {
//        	if(self.cp == null) {
//            	self.cp = new CryptoPrice();
//			}
//			
//			var type = "SPOT";
//			if(data["instrument_id"].equals("BTC-USDT")){
//				self.cp.curSpotPrice = data["last"].toFloat();
//			}else if(data["instrument_id"].equals("BTC-USD-SWAP")){
//				self.cp.curSwapPrice = data["last"].toFloat();
//				type = "SWAP";
//			}else{
//				self.cp.curFuturePrice = data["last"].toFloat();
//				type = "FUTURE";
//			}
//			//Ui.switchToView(new okexView(cp), null, Ui.SLIDE_IMMEDIATE);
////			Ui.requestUpdate();
////			Sys.println(data["instrument_id"]+"|"+type+"|"+data["last"]);
//           	notify.invoke(data["last"].toFloat(), type);
//        }else { //If error in getting data from JSON API
//        		Sys.println("Data request failed\nWith response: ");
//        		Sys.println(responseCode);
//        }
//    }
//}