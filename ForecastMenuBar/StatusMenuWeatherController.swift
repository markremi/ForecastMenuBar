//
//  StatusMenuWeatherController.swift
//  ForecastMenuBar
//
//  Created by Mark Remi on 10/3/15.
//  Copyright © 2015 Mark Remi. All rights reserved.
//

import Cocoa

let DEFAULT_CITY: String = "Charleston,SC"
var timer: NSTimer?

// Timers
let DEFAULT_TIMER_INTERVAL_IN_SECONDS : NSTimeInterval = 900

// Errors
let INTERNET_CONNECTIVITY_ERROR = "..We are off the grid."
let HTTP_ERROR = "..Trouble retrieving data."


class StatusMenuWeatherController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    let weatherAPI = WeatherAPI()

    override func awakeFromNib() {
        statusItem.title = "... Retrieving local weather"
        statusItem.toolTip = "Local weather"
        statusItem.menu = statusMenu
        
        updateWeather()
        startTimer(DEFAULT_TIMER_INTERVAL_IN_SECONDS)
    }
    
    /**
        Get weather update.
    */
    func updateWeather() {
        
        // Refresh local weather.
        let defaults = NSUserDefaults.standardUserDefaults()
        let city = defaults.stringForKey("city") ?? DEFAULT_CITY
        
        _ = weatherAPI.getWeatherByCity(city) { data, error in
            
            // Handle error.
            if (error != nil) {
                print ("Encountered error during API call:")
                print (error)
                self.statusItem.title = INTERNET_CONNECTIVITY_ERROR
                return
            }
            
            let weather = self.weatherAPI.parseJSON(data!)
            
            if (weather?.httpCode != 200) {
                self.statusItem.title = HTTP_ERROR
                return
            }
            
            // Format Strings.
            let temp = NSString(
                format: "%.1f° ",
                weather!.currentTemp) as String
            let conditions = weather!.conditions.capitalizedString
        
            // Grab icon.
            let icon = self.weatherAPI.getIcon(weather!.icon)
        
            // Set values on status menu bar.
            self.statusItem.image = icon
            self.statusItem.title = temp + conditions
        }
    }
    
    /**
        Kick off a timer to refresh weather every x intervals in seconds.
        - Parameters:
            - minutes: Interval for timer.
    */
    func startTimer(seconds : NSTimeInterval) {
        timer = NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: "updateWeather", userInfo: nil, repeats: true)
    }
    
    /**
        Stop timer.
    */
    func stopTimer() {
        timer!.invalidate()
    }
    
    @IBAction func refreshClicked(sender: NSMenuItem) {
        updateWeather()
    }
    
    @IBAction func preferencesClicked(sender: NSMenuItem) {
        // Preferences.
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        // Quit application.
        NSApplication.sharedApplication().terminate(self)
    }
}
