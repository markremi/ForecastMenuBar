//
//  StatusMenuWeatherController.swift
//  ForecastMenuBar
//
//  Created by Mark Remi on 10/3/15.
//  Copyright © 2015 Mark Remi. All rights reserved.
//

import Cocoa
let DEFAULT_CITY: String = "Charleston, SC"
let ERROR_MESSAGE = "..Trouble retrieving data"

class StatusMenuWeatherController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    let weatherAPI = WeatherAPI()

    override func awakeFromNib() {
        statusItem.title = "... Retrieving local weather"
        statusItem.toolTip = "Local weather"
        statusItem.menu = statusMenu
        
        updateWeather()
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
                self.statusItem.title = ERROR_MESSAGE
                return
            }
            
            let weather = self.weatherAPI.parseJSON(data!)
            
            if (weather?.httpCode != 200) {
                self.statusItem.title = ERROR_MESSAGE
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
