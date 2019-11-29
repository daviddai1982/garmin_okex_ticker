using Toybox.Application;
using Toybox.WatchUi;

class okexApp extends Application.AppBase {

	hidden var View;
//    hidden var Model;
    hidden var Delegate;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	View = new okexView();
//    	Model = new PriceModel(View.method(:onPrice));
    	Delegate = new okexDelegate();
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ View, Delegate ];
    }

}
