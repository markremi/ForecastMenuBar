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
var menuBarText = [String]()
var weather: Weather?

// Timers
let DEFAULT_TIMER_INTERVAL_IN_SECONDS : NSTimeInterval = 900

// Errors
let INTERNET_CONNECTIVITY_ERROR = "..We are off the grid."
let HTTP_ERROR = "..Trouble retrieving data."


class StatusMenuWeatherController: NSObject {
    
    /// Menu Items
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var refreshSlider: NSSlider!
    @IBOutlet weak var refreshIntervalText: NSMenuItem!
    @IBOutlet weak var optionsView: NSSplitView!
    
    /// Options
    @IBOutlet weak var iconButton: NSButton!
    
    
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    let weatherAPI = WeatherAPI()

    override func awakeFromNib() {
        
        // Let's build UI here.
        let refreshSliderMenuItem = NSMenuItem()
        refreshSliderMenuItem.view = refreshSlider
        statusMenu.insertItem(refreshSliderMenuItem, atIndex: 3)
        
        let optionsViewMenuItem = NSMenuItem()
        optionsViewMenuItem.view = optionsView
        statusMenu.insertItem(optionsViewMenuItem, atIndex: 5)
        

        // Set default settings.
        statusItem.title = "... Retrieving local weather"
        statusItem.toolTip = "Local weather"
        statusItem.menu = statusMenu
        refreshIntervalText.title = String(refreshSlider.intValue) + " Min Refresh Interval"

        updateWeather()
        startTimer(DEFAULT_TIMER_INTERVAL_IN_SECONDS)
    }
    
    
    /**
        Update refresh interval text and update timer interval.
    */
    @IBAction func refreshIntervalMovement(sender: NSSliderCell) {
        
        // Update slider.
        refreshIntervalText.title = String(sender.intValue) + " Min Refresh Interval"
        
        // Get mouse event for mouseUp.
        let anEvent = NSApplication.sharedApplication().currentEvent
        
        let mouseUp = anEvent?.type == NSEventType.LeftMouseUp
        if (mouseUp) {
            
            // Update interval.
            stopTimer()
            startTimer(Double(sender.intValue)*60)
        }
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
            
            weather = self.weatherAPI.parseJSON(data!)
            
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
    
    /// Option Buttons
    @IBAction func iconButtonAction(sender: NSButton) {
        
        if (sender.state == NSOnState) {
            let icon = self.weatherAPI.getIcon(weather!.icon)
            self.statusItem.image = icon
        } else {
            self.statusItem.image = nil
        }
    }
    
}
