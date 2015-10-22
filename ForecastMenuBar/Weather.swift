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
    var region: String
    var currentTemp: Float
    var conditions: String
    var icon: String
    var httpCode: Int
    var cloud: Int
    var id: Int
    var windChill: Float
    var windSpeed: Int
    var windDirection: String
    var sunrise: NSDate
    var sunset: NSDate
    var humidity: Int
    var maximumTemperature: Float
    var minimumTemperature: Float
    var pressure: Int
    var latitude: Float
    var longitude: Float
    var visibility: Int
    var feelsLike: Float
    var precipitation: Float

    init() {
        city = ""
        country = ""
        region = ""
        currentTemp = 0
        conditions = ""
        icon = ""
        httpCode = 0
        cloud = 0
        id = 0
        windChill = 0
        windSpeed = 0
        windDirection = ""
        sunrise = NSDate()
        sunset = NSDate()
        humidity = 0
        maximumTemperature = 0
        minimumTemperature = 0
        pressure = 0
        latitude = 0
        longitude = 0
        visibility = 0
        feelsLike = 0
        precipitation = 0
    }
}