using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Communications as Comm;
using Toybox.System as Sys;
using Toybox.Timer;
using Toybox.Graphics;

class MyConfirmationDelegate extends WatchUi.ConfirmationDelegate {
		hidden var _handler;
	    function initialize(view) {
	    	_handler = view;
	        ConfirmationDelegate.initialize();
	    }
	
	    function onResponse(response) {
	        if (response == WatchUi.CONFIRM_YES) {
	            _handler.startTimer();
	        }
	    }
	}

class okexView extends WatchUi.View {
	hidden var viewSpot;
	hidden var viewSpotPercent;
	hidden var viewSpotHigh;
	hidden var viewSpotLow;
	hidden var viewFutrue;
	hidden var viewFutrueHigh;
	hidden var viewFutrueLow;
	hidden var viewSwap;
	hidden var viewSwapHigh;
	hidden var viewSwapLow;
	hidden var viewTime;
	hidden var _cp = new CryptoPrice();
//	hidden var _pm;
	
//	hidden var okexApi = "https://www.okex.me";
//	hidden var cryptoSpotPriceURL = okexApi + "/api/spot/v3/instruments/BTC-USDT/ticker";
//	hidden var cryptoFuturePriceURL = okexApi + "/api/futures/v3/instruments/BTC-USD-200327/ticker";
//	hidden var cryptoSwapPriceURL = okexApi + "/api/swap/v3/instruments/BTC-USD-SWAP/ticker";
	
	hidden var timerSwitch = false;
	var myTimer;
	
    function initialize() {
    	View.initialize();
    }
    
    function startTimer(){
    	myTimer.start(method(:fetchPrice), 4000, true);
    }

    // Load your resources here
    function onLayout(dc) {
    	setLayout(Rez.Layouts.MainLayout(dc));
    	
    	viewSpot = WatchUi.View.findDrawableById("spot");
    	viewSpotPercent = WatchUi.View.findDrawableById("spot_percent");
    	viewSpotHigh = WatchUi.View.findDrawableById("spot_high");
    	viewSpotLow = WatchUi.View.findDrawableById("spot_low");
    	
    	viewFutrue = WatchUi.View.findDrawableById("future");
    	viewFutrueHigh = WatchUi.View.findDrawableById("future_high");
    	viewFutrueLow = WatchUi.View.findDrawableById("future_low");
    	
    	viewSwap = WatchUi.View.findDrawableById("swap");
    	viewSwapHigh = WatchUi.View.findDrawableById("swap_high");
    	viewSwapLow = WatchUi.View.findDrawableById("swap_low");
    	
    	viewTime = WatchUi.View.findDrawableById("time");
    	
    	myTimer = new Timer.Timer();
    	
    	fetchPrice();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	
		viewSpot.setText("----");

		viewFutrue.setText("----");

		viewSwap.setText("----");
		
		viewTime.setText("--:--:--");
		
    }

    // Update the view
    function onUpdate(dc) {
    	if(_cp instanceof CryptoPrice){
    		if(_cp.curSpotPrice.last > 0){
    			if(viewSpot!=null){
    				var diff = (_cp.curSpotPrice.last - _cp.curSpotPrice.open)/_cp.curSpotPrice.open * 100;
    				viewSpot.setText(_cp.curSpotPrice.last.format("%.2f"));
    				viewSpotPercent.setText(diff.format("%.2f")+"%");
    				if(diff>0){
    					viewSpotPercent.setColor(Graphics.COLOR_GREEN);
    				}else{
    					viewSpotPercent.setColor(Graphics.COLOR_RED);
    				}
    				viewSpotHigh.setText("H:" + _cp.curSpotPrice.high.format("%.2f"));
    				viewSpotLow.setText("L:" + _cp.curSpotPrice.low.format("%.2f"));
    			}
    		}
    		if(_cp.curFuturePrice.last > 0){
	    		if(viewFutrue!=null){
	    			viewFutrue.setText(_cp.curFuturePrice.last.format("%.2f"));
	    			viewFutrueHigh.setText("H:" + _cp.curFuturePrice.high.format("%.2f"));
	    			viewFutrueLow.setText("L:" + _cp.curFuturePrice.low.format("%.2f"));
    			}
    		}
    		if(_cp.curSwapPrice.last > 0){
	    		if(viewSwap!=null){
	    			viewSwap.setText(_cp.curSwapPrice.last.format("%.2f"));
	    			viewSwapHigh.setText("H:" + _cp.curSwapPrice.high.format("%.2f"));
	    			viewSwapLow.setText("L:" + _cp.curSwapPrice.low.format("%.2f"));
    			}
    		}
    	}
        // Call the parent onUpdate function to redraw the layout
		
		var today = Gregorian.info(Time.now(), Time.FORMAT_LONG);
		
		var dateString = Lang.format(
		    "$1$:$2$:$3$",
		    [
		        today.hour.format("%02d"),
		        today.min.format("%02d"),
		        today.sec.format("%02d")
		    ]
		);
		
		viewTime.setText(dateString);
//        
        View.onUpdate(dc);
    }
    
    function fetchPrice(){
    	if (Toybox has :Communications) {
    		if(isConnectionAvailable()){
    			// Get current price and coin symbol from API
				Comm.makeWebRequest(cryptoSpotPriceURL,
			         				 {}, 
			         				 {}, 
			         				 method(:onReceiveData));
			    Comm.makeWebRequest(cryptoFuturePriceURL,
			         				 {}, 
			         				 {}, 
			         				 method(:onReceiveData));
			    Comm.makeWebRequest(cryptoSwapPriceURL,
			         				 {}, 
			         				 {}, 
			         				 method(:onReceiveData));
    		}else { //If communication fails
				myTimer.stop();
	      		var message = "请确认手机已连接:(";
				var dialog = new WatchUi.Confirmation(message);
				WatchUi.pushView(
				    dialog,
				    new MyConfirmationDelegate(self),
				    WatchUi.SLIDE_IMMEDIATE
				);
	      	}
		}
    }
    
    function onReceiveData(responseCode, data) {
        if(responseCode == 200) {
        	if(_cp == null) {
            	_cp = new CryptoPrice();
			}
			
			var type = "SPOT";
			if(data["instrument_id"].equals("BTC-USDT")){
				_cp.curSpotPrice.last = data["last"].toFloat();
				_cp.curSpotPrice.low = data["low_24h"].toFloat();
				_cp.curSpotPrice.high = data["high_24h"].toFloat();
				_cp.curSpotPrice.open = data["open_24h"].toFloat();
			}else if(data["instrument_id"].equals("BTC-USD-SWAP")){
				_cp.curSwapPrice.last = data["last"].toFloat();
				_cp.curSwapPrice.low = data["low_24h"].toFloat();
				_cp.curSwapPrice.high = data["high_24h"].toFloat();
				type = "SWAP";
			}else{
				_cp.curFuturePrice.last = data["last"].toFloat();
				_cp.curFuturePrice.low = data["low_24h"].toFloat();
				_cp.curFuturePrice.high = data["high_24h"].toFloat();
				type = "FUTURE";
			}
			//Ui.switchToView(new okexView(cp), null, Ui.SLIDE_IMMEDIATE);
//			Ui.requestUpdate();
//			Sys.println(data["instrument_id"]+"|"+type+"|"+data["last"]);
           	self.onPrice(type);
        }else { //If error in getting data from JSON API
        		Sys.println("Data request failed\nWith response: ");
        		Sys.println(responseCode);
        }
    }
    
    function onPrice(type){
    	switch(type){
    		case "SPOT":
//    			_cp.curSpotPrice = value;
    			WatchUi.requestUpdate();
    			break;
    		case "SWAP":
//    			_cp.curSwapPrice = value;
    			WatchUi.requestUpdate();
    			break;
    		case "ERROR":
    			if(myTimer != null){
    				myTimer.stop();
    			}
    			var message = "手机未连接，是否重试？";
				var dialog = new WatchUi.Confirmation(message);
				WatchUi.pushView(
				    dialog,
				    new MyConfirmationDelegate(),
				    WatchUi.SLIDE_UP
				);
//				WatchUi.requestUpdate();
    			break;
    		default:
//    			_cp.curFuturePrice = value;
    			WatchUi.requestUpdate();
    		   
    	}
    	
    	
    	
    	if(_cp.curSpotPrice.last>0 && _cp.curSwapPrice.last>0 && _cp.curFuturePrice.last>0 && timerSwitch == false){
    		timerSwitch = true;
    		myTimer.start(method(:fetchPrice), 4000, true);
    	}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	myTimer.stop();
    }

}
