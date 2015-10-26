//
//  StatusMenuWeatherController.swift
//  ForecastMenuBar
//
//  Created by Mark Remi on 10/3/15.
//  Copyright © 2015 Mark Remi. All rights reserved.
//

import Cocoa

var DEFAULT_CITY: String = "Charleston,SC"
var timer: NSTimer?
var weather: Weather?

// Timers
let DEFAULT_TIMER_INTERVAL_IN_SECONDS : NSTimeInterval = 900

// Errors
let INTERNET_CONNECTIVITY_ERROR = "..We are off the grid."
let HTTP_ERROR = "..Trouble retrieving data."


class StatusMenuWeatherController: NSObject {
    
    /// Menu Items
    @IBOutlet weak var statusMenu: NSMenu!
    
    @IBOutlet weak var cityView: NSView!
    @IBOutlet weak var cityTextField: NSTextField!

    
//    @IBOutlet weak var cityTextField: NSTextField!
//    @IBOutlet weak var cityView: NSTableCellView!
    @IBOutlet weak var idLabel: NSTextField!
    
    @IBOutlet weak var refreshSlider: NSSlider!
    @IBOutlet weak var refreshSliderView: NSView!
    @IBOutlet weak var refreshIntervalText: NSTextField!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let weatherAPI = WeatherAPI()

    override func awakeFromNib() {
        
        setDefaults()
        
        // Let's build UI here.
        let cityMenuItem = NSMenuItem()
        cityMenuItem.view = cityView
        statusMenu.insertItem(cityMenuItem, atIndex: 3)
        
        let refreshSliderMenuItem = NSMenuItem()
        refreshSliderMenuItem.view = refreshSliderView
        statusMenu.insertItem(refreshSliderMenuItem, atIndex: 5)
        
        // Set default settings.
        self.statusItem.title = "... Retrieving local weather"
        self.statusItem.toolTip = "Local weather"
        self.statusItem.menu = statusMenu
        refreshIntervalText.stringValue = String(refreshSlider.intValue) + " Min Refresh Interval"

        updateWeather(DEFAULT_CITY)
        startTimer(Double(refreshSlider.intValue)*60)
    }
    
    /**
        Update refresh interval text and update timer interval.
    */
    @IBAction func refreshIntervalMovement(sender: NSSlider) {
        // Update slider.
        refreshIntervalText.stringValue = String(sender.intValue) + " Min Refresh Interval"
        
        // Get mouse event for mouseUp.
        let anEvent = NSApplication.sharedApplication().currentEvent
        
        let mouseUp = anEvent?.type == NSEventType.LeftMouseUp
        if (mouseUp) {
        
            // Update interval.
            stopTimer()
            startTimer(Double(sender.intValue)*60)
        }
    }

    @IBAction func cityTextFieldChanges(sender: NSTextField) {
        // Select All
        // Get mouse event for mouseUp.
        let anEvent = NSApplication.sharedApplication().currentEvent
        let mouseDown = anEvent?.type == NSEventType.MouseEntered
        if (mouseDown) {
            sender.selectAll(self)
        }
        
        // cityTextField.resignFirstResponder()
        DEFAULT_CITY = sender.stringValue
        sender.stringValue = DEFAULT_CITY.capitalizedString
        updateWeather(DEFAULT_CITY)
    }
    
    /**
        Get weather update.
    */
    func updateWeather(city: String) {
        
        weatherAPI.getWeatherByCity(city) { data, error in
            
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
            
            print (weather!.id)
            
            // Update city name
            if !(weather!.city.isEmpty) {
                self.cityTextField.stringValue = (weather?.city)! + ", " + (weather?.country)!
                self.idLabel.stringValue = "Id: " + weather!.id.description
            }
        }
    }
    
    /**
        Kick off a timer to refresh weather every x inervals in seconds.
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
        updateWeather(DEFAULT_CITY)
    }
    
    @IBAction func preferencesClicked(sender: NSMenuItem) {
        // Preferences.
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        // Quit application.
        NSApplication.sharedApplication().terminate(self)
    }
    
    /**
        Set application defaults.
    */
    func setDefaults() {
        refreshSlider.intValue = 30
        refreshIntervalText.textColor = NSColor.grayColor()
        cityTextField.textColor = NSColor.blackColor()
        idLabel.textColor = NSColor.grayColor()
    }
}

class TextFieldSubclass: NSTextField {
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent)
        if let textEditor = currentEditor() {
            textEditor.selectAll(self)
        }
    }
}