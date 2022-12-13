import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class ciq_ekidenTime_watchfaceView extends WatchUi.WatchFace {
	hidden var bgbitmap = null;
	hidden var fontTime = null;
	hidden var fontBattery = null;
	hidden var fontBatteryIcons = null;
	hidden var fontDate = null;
	hidden var fontSteps = null;
	hidden var fontStepsIcons = null;
	hidden var stats = null;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        
        switch (Application.getApp().getProperty("BGMode")) {
        	case 0:
        		bgbitmap = WatchUi.loadResource(Rez.Drawables.id_hakone_dt);
        		break;
        	case 1:
        		bgbitmap = WatchUi.loadResource(Rez.Drawables.id_hakone_tt);
        		break;
        	case 2:
        		bgbitmap = WatchUi.loadResource(Rez.Drawables.id_hakone);
        		break;
        	default:
        		bgbitmap = WatchUi.loadResource(Rez.Drawables.id_hakone_ep);
        }
    	    
        fontTime = WatchUi.loadResource(Rez.Fonts.time);
        fontBattery = WatchUi.loadResource(Rez.Fonts.battery);
        fontBatteryIcons = WatchUi.loadResource(Rez.Fonts.batteryIcons);
        fontDate = WatchUi.loadResource(Rez.Fonts.date);
        fontSteps = WatchUi.loadResource(Rez.Fonts.steps);
        fontStepsIcons = WatchUi.loadResource(Rez.Fonts.stepsIcons);
    }

    // Called when this View is brought to the foreground. Restore the state of this View and prepare it to be shown. This includes loading resources into memory.
    function onShow() {
    }

    function onUpdate(dc) {
		dc.clear();
        
        var halfwidth = dc.getWidth()/2;
        var halfheight = dc.getHeight()/2;
        
	    dc.drawBitmap(halfwidth-(bgbitmap.getWidth()/2), halfheight-(bgbitmap.getHeight()/2), bgbitmap);
	    
	    if (Application.getApp().getProperty("Date")) {
		    var gregorian = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		    var date = null;
		    if (Application.getApp().getProperty("DateYear") > 1) {
		    	date = Lang.format("$1$ $2$", [gregorian.day, gregorian.month.toUpper()]);
		    } else {
		    	var year = gregorian.year;
		    	if (Application.getApp().getProperty("DateYear") > 0) {
				    year = year.toString().substring(2, 4);
				}
				date = Lang.format("$1$ $2$ $3$", [gregorian.day, gregorian.month.toUpper(), year]);
			}
		    //var date = Lang.format("$1$ $2$ $3$", [gregorian.day, gregorian.month.toUpper(), year]);
	    	dc.setColor(Application.getApp().getProperty("DateColor"), Graphics.COLOR_TRANSPARENT);
	    	dc.drawText(halfwidth, halfheight-Math.ceil(halfheight/1.333), fontDate, date, Graphics.TEXT_JUSTIFY_CENTER);
	    }
	    
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours-12;
            }
        }
        var halfwidthoffset = halfwidth/30;
        var halfheightwithoffset = halfheight-80;
        dc.setColor(Application.getApp().getProperty("HoursColor"), Graphics.COLOR_TRANSPARENT);
        //dc.setColor(0x00003b, Graphics.COLOR_TRANSPARENT);
        dc.drawText(halfwidth-halfwidthoffset, halfheightwithoffset, fontTime, hours.toString(), Graphics.TEXT_JUSTIFY_RIGHT);
        dc.setColor(Application.getApp().getProperty("MinutesColor"), Graphics.COLOR_TRANSPARENT);
        dc.drawText(halfwidth+halfwidthoffset, halfheightwithoffset, fontTime, Lang.format("$1$", [clockTime.min.format("%02d")]), Graphics.TEXT_JUSTIFY_LEFT);
        
        var steps = ActivityMonitor.getInfo().steps;
        //steps = 208;
        if (Application.getApp().getProperty("Steps") && steps != null) {
        	var fontStepsbase = 13+1;
        	var stepswidthoffset = ((fontStepsbase*steps.toString().length())*0.5)+fontStepsbase;
        	var connecticonsoffset = 17*0.5;
        	var stepsheight = halfheight+Math.ceil(halfheight/2.25);
        	dc.setColor(Application.getApp().getProperty("StepsColor"), Graphics.COLOR_TRANSPARENT);
        	dc.drawText(halfwidth-(stepswidthoffset-connecticonsoffset), stepsheight-4, fontStepsIcons, "0", Graphics.TEXT_JUSTIFY_CENTER);
        	dc.drawText(halfwidth+connecticonsoffset, stepsheight, fontSteps, steps.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        if (Application.getApp().getProperty("BatteryStatus")) {
        	stats = System.getSystemStats();
        	//var batterylife = Lang.format("$1$", [stats.battery.format("%01d")]);
        	var batterylife = stats.battery.format("%01d").toString();
        	//batterylife = "100";
        	var fontBatterybase = 25+1;
        	var batterylifewidthoffset = ((fontBatterybase*batterylife.length())*0.5)+(fontBatterybase*0.5);
        	var connecticonsoffset = 26*0.5;
        	var batterylifeheight = halfheight+Math.ceil(halfheight/1.5);
        	dc.setColor(Application.getApp().getProperty("BatteryColor"), Graphics.COLOR_TRANSPARENT);
        	dc.drawText(halfwidth-(batterylifewidthoffset-connecticonsoffset), batterylifeheight-6, fontBatteryIcons, "0", Graphics.TEXT_JUSTIFY_CENTER);
        	dc.drawText(halfwidth+connecticonsoffset, batterylifeheight, fontBattery, batterylife, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    // Called when this View is removed from the screen. Save the state of this View here. This includes freeing resources from memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }
}
