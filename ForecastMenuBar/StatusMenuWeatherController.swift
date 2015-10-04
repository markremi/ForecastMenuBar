//
//  StatusMenuWeatherController.swift
//  ForecastMenuBar
//
//  Created by Mark Remi on 10/3/15.
//  Copyright © 2015 Mark Remi. All rights reserved.
//

import Cocoa

class StatusMenuWeatherController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    let weatherAPI = WeatherAPI()

    override func awakeFromNib() {
        statusItem.title = "Weather Forecast Bar"
        statusItem.toolTip = ".. local weather"
        statusItem.menu = statusMenu
    }
    
    @IBAction func refreshClicked(sender: NSMenuItem) {
        // Refresh local weather.
        weatherAPI.getWeatherByCity("Seattle")
    }
    
    @IBAction func preferencesClicked(sender: NSMenuItem) {
        // Preferences.
        
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        // Quit application.
        NSApplication.sharedApplication().terminate(self)
    }
}
