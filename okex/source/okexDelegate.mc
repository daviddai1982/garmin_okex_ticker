using Toybox.WatchUi;

class okexDelegate extends WatchUi.BehaviorDelegate {
//    hidden var Model;
    
    function initialize() {
        BehaviorDelegate.initialize();
//        Model = priceModel;
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new okexMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}