//
//  WeatherAPI.swift
//  ForecastMenuBar
//
//  Created by Mark Remi on 10/3/15.
//  Copyright © 2015 Mark Remi. All rights reserved.
//

import Foundation
import Cocoa

/// Base url for Openweathermap
let BASE_URL : String = "http://api.openweathermap.org/data/2.5/weather?"
//let BASE_URL : String = "http://api.openweathermap.org/data/2.5/forecast/daily?&cnt=1"
let ICON_URL : String = "http://openweathermap.org/img/w/"
let ICON_EXTENSION : String = ".png"
let ICON_SIZE: CGFloat = 30

/// App id.
let APP_ID = "fecc856e95228926c6d5e20b245bde91"

class WeatherAPI {

    /**
        Get weather information based on city.
        - Parameters:
            - city: Candidate for weather conditions.
    */
    func getWeatherByCity(city: String, completionHandler: (NSData?, NSError?) -> Void) -> NSURLSessionTask  {

        let URL = BASE_URL + "&APPID=" + APP_ID + "&q="
        
        /// Set up session.
        let session = NSURLSession.sharedSession()
        
        /// Create API URL string.
        let escapedQuery = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let requestURL = NSURL(string: URL + escapedQuery!)
        
        /// Asynchronous call. Needs special handling.
        let sessionTask = session.dataTaskWithURL(requestURL!) {
            (data, response, error) in
            
            // Using the completionHandler override so we can get this value synchronously (like the rest of the applicaiton)
            completionHandler(data, error)
        }
        
        sessionTask.resume()
        return sessionTask
    }
    
    /**
        Transform NSData to JSON, then parse value to Weather struct.
    
        - Parameters:
            - data: JSON data.
    */
    func parseJSON(data: NSData) -> Weather? {
        
        let json = JSON(data: data)
        if (json != nil) {
            NSLog("%@", "Json value: ")
            print(json)
        } else {
            print("JSON is nil!")
        }
       
        // Build weather
        let weather = Weather()
        weather.httpCode = json["cod"].intValue
        
        // If successful...
        if (weather.httpCode == 200) {
            
            // TODO: Possible nil value here?
            weather.currentTemp = convertKelvinToFahrenheit(json["main"]["temp_min"].floatValue)
            
            // Lets grab all the JSON values here.
            weather.city = json["name"].stringValue
            weather.country = json["sys"]["country"].stringValue
            weather.windDirection = json["wind"]["speed"].floatValue
            weather.windChill = json["wind"]["deg"].floatValue
            weather.sunrise = NSDate(timeIntervalSince1970: json["sys"]["sunrise"].doubleValue)
            weather.sunset = NSDate(timeIntervalSince1970: json["sys"]["sunset"].doubleValue)
            weather.humidity = json["main"]["humidity"].intValue
            weather.maximumTemperature = json["main"]["temp_max"].floatValue
            weather.minimumTemperature = json["main"]["temp_min"].floatValue
            weather.pressure = json["main"]["pressure"].intValue
            weather.longitude = json["coord"]["lon"].floatValue
            weather.latitude = json["coord"]["lat"].floatValue
            weather.visibility = json["visibility"].intValue
            
            // Only the first list item matters.
            weather.id = json["id"].intValue
            weather.conditions = json["weather"][0]["main"].stringValue
            weather.icon = json["weather"][0]["icon"].stringValue
            weather.cloudiness = json["weather"][0]["description"].stringValue
        }
        
        return weather
    }
    
    /**
        Retrieve icon for weather.
        - Parameters
            - iconId: The unique identification for icon location.
    */
    func getIcon(iconId: String) -> NSImage {
        let iconRequestURL = NSURL(string: ICON_URL + iconId + ICON_EXTENSION)
        let icon = NSImage(byReferencingURL: iconRequestURL!)
        icon.size = NSMakeSize(ICON_SIZE, ICON_SIZE)
        return icon
    }
    
    /**
        Convert kelvin to fahrenheit.
        - Parameters:
            - kelvin: Temperature in kelvin.
    */
    func convertKelvinToFahrenheit(kelvin: Float) -> Float {
        return ((9/5)*(kelvin-273)+32)
    }
}