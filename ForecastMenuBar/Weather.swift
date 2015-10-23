//
//  Weather.swift
//  ForecastMenuBar
//
//  Created by Mark Remi on 10/19/15.
//  Copyright © 2015 Mark Remi. All rights reserved.
//

import Foundation

/**
    Basic Weather object.
    - Parameters:
        - city
        - currentTemp: Current temperature.
        - conditions: Current weather description.
        - icon: Weather condition status icon.
        - httpCode: Possible error HTTP error codes.
        - cloudiness: Clear skies.
        - id: City identification.
        - windSpeed: Wind speed.
        - windChill: Wind chill temperature.
*/
class Weather {
    
    var city: String
    var country: String
    var currentTemp: Float
    var conditions: String
    var icon: String
    var httpCode: Int
    var cloudiness: String
    var id: Int
    var windDirection: Float
    var windChill: Float
    var sunrise: NSDate
    var sunset: NSDate
    var humidity: Int
    var maximumTemperature: Float
    var minimumTemperature: Float
    var pressure: Int
    var latitude: Float
    var longitude: Float
    var visibility: Int

    init() {
        city = ""
        country = ""
        currentTemp = 0
        conditions = ""
        icon = ""
        httpCode = 0
        cloudiness = ""
        id = 0
        windDirection = 0
        windChill = 0
        sunrise = NSDate()
        sunset = NSDate()
        humidity = 0
        maximumTemperature = 0
        minimumTemperature = 0
        pressure = 0
        latitude = 0
        longitude = 0
        visibility = 0
    }
}