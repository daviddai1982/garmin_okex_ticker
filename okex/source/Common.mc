using Toybox.System as Sys;

var okexApi = "https://www.okex.me";
var cryptoSpotPriceURL = okexApi + "/api/spot/v3/instruments/BTC-USDT/ticker";
var cryptoFuturePriceURL = okexApi + "/api/futures/v3/instruments/BTC-USD-200327/ticker";
var cryptoSwapPriceURL = okexApi + "/api/swap/v3/instruments/BTC-USD-SWAP/ticker";

function isConnectionAvailable() {
	var info = Sys.getDeviceSettings();
	if(info has :connectionAvailable){
		//For CIQ >=3
		return info.connectionAvailable;
	} else {
		//For CIQ 1 & 2
		return info.phoneConnected;
	}
}
