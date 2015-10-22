//
//  WeatherAPI.swift
//  ForecastMenuBar
//
//  Created by Mark Remi on 10/3/15.
//  Copyright © 2015 Mark Remi. All rights reserved.
//

import Foundation
import Cocoa
import SwiftyJSON

/// Base url for Openweathermap
let BASE_URL : String = "http://api.apixu.com/v1/current.json?" // apixu.com
let ICON_URL : String = "http://openweathermap.org/img/w/"
let ICON_EXTENSION : String = ".png"
let ICON_SIZE: CGFloat = 30

/// App id.
let APP_ID = "3b8fcd75998d4e6584330944152210" // apixu.com

class WeatherAPI {

    /**
        Get weather information based on city.
        - Parameters:
            - city: Candidate for weather conditions.
    */
    func getWeatherByCity(city: String, completionHandler: (NSData?, NSError?) -> Void) -> NSURLSessionTask  {

        let URL = BASE_URL + "&key=" + APP_ID + "&q="
        
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
        weather.city = json["location"]["name"].stringValue
        
        // If successful...
        if (weather.city != "") {
            
            // TODO: Possible nil value here?
            weather.currentTemp = json["current"]["temp_f"].floatValue
            weather.httpCode = 200
            
//                {
//                    "current" : {
//                        "wind_degree" : 0,
//                        "condition" : {
//                            "code" : 1009,
//                            "text" : "Overcast",
//                            "icon" : "\/\/cdn.apixu.com\/weather\/64x64\/night\/122.png"
//                        },
//                        "pressure_mb" : 1026,
//                        "last_updated_epoch" : 1445470206,
//                        "last_updated" : "2015-10-21 23:30",
//                        "temp_c" : 19,
//                        "wind_dir" : "N",
//                        "wind_mph" : 0,
//                        "precip_in" : 0,
//                        "humidity" : 94,
//                        "cloud" : 100,
//                        "feelslike_f" : 66.2,
//                        "temp_f" : 66.2,
//                        "wind_kph" : 0,
//                        "pressure_in" : 30.8,
//                        "precip_mm" : 0,
//                        "feelslike_c" : 19
//                    },
//                    "location" : {
//                        "region" : "South Carolina",
//                        "country" : "United States Of America",
//                        "localtime" : "2015-10-21 23:33",
//                        "lon" : -79.93000000000001,
//                        "lat" : 32.78,
//                        "tz_id" : "America\/New_York",
//                        "name" : "Charleston",
//                        "localtime_epoch" : 1445470431
//                    }
//            }
            
            
            // Lets grab all the JSON values here.
            weather.region = json["location"]["region"].stringValue
            weather.country = json["location"]["country"].stringValue
            weather.windSpeed = json["wind_mph"].intValue
            weather.windDirection = json["wind_dir"].stringValue
            weather.windChill = json["current"]["wind_degree"].floatValue
            weather.humidity = json["humidity"].intValue
            weather.maximumTemperature = json["main"]["temp_max"].floatValue
            weather.minimumTemperature = json["main"]["temp_min"].floatValue
            weather.pressure = json["pressure_mb"].intValue
            weather.longitude = json["coord"]["lon"].floatValue
            weather.latitude = json["coord"]["lat"].floatValue
            weather.visibility = json["visibility"].intValue
            weather.feelsLike = json["feelslike_f"].floatValue
            weather.precipitation = json["precip_in"].floatValue
            
            // Only the first list item matters.
            weather.conditions = json["current"]["condition"]["text"].stringValue
            weather.icon = json["current"]["condition"]["icon"].stringValue
            weather.cloud = json["cloud"].intValue
        }
        
        return weather
    }
    
    /**
        Retrieve icon for weather.
        - Parameters
            - iconId: The unique identification for icon location.
    */
    func getIcon(iconId: String) -> NSImage {
        let iconRequestURL = NSURL(string: "http:" + iconId)
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