//
//  WeatherAPI.swift
//  ForecastMenuBar
//
//  Created by Mark Remi on 10/3/15.
//  Copyright © 2015 Mark Remi. All rights reserved.
//

import Foundation
import SwiftyJSON

// Basic Weather object.
struct Weather {
    var city: String
    var currentTemp: Float
    var conditions: String
}

class WeatherAPI {
    
    // Base url for Openweathermap.
    let URL = "http://api.openweathermap.org/data/2.5/weather?units=imperial&APPID=fecc856e95228926c6d5e20b245bde91&q="
   

    func getWeatherByCity(city: String, completionHandler: (NSData?, NSError?) -> Void) -> NSURLSessionTask  {
        
        // Set up session.
        let session = NSURLSession.sharedSession()
        
        // Create API URL string.
        let escapedQuery = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let requestURL = NSURL(string: URL + escapedQuery!)
        
        // Asynchronous call. Needs special handling.
        let sessionTask = session.dataTaskWithURL(requestURL!) {
            (data, response, error) in
            
            // Using the completionHandler override so we can get this value synchronously (like the rest of the applicaiton)
            completionHandler(data, error)
        }
        
        sessionTask.resume()
        return sessionTask
    }
    
//    func getWeatherByCity(city: String) {
//        
//        // Set up session.
//        let session = NSURLSession.sharedSession()
//        let escapedQuery = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
//
//        // Creating empty Weather
//        var weather : Weather? = nil
//        
//        let requestURL = NSURL(string: URL + escapedQuery!)
//        let task = session.dataTaskWithURL(requestURL!) {
//            (data, response, error) in
//            
//            // Get weather from parseJSON
//            parseJSON(data!)!
//        }
//        
//        task.resume()
//    }
    
    func parseJSON(data: NSData) -> Weather? {
        
        let json = JSON(data: data)
        if (json != nil) {
            print("JSON value : ")
            print(json)
        } else {
            print("JSON is nil!")
        }

        let city = json["name"].string
        let temperature = json["main"]["temp"].float
        
        // List of weather codes
        var id:Int
        var main:String
        var icon:String
        var description = ""
        
        for climate in json["weather"].arrayValue {
            id = climate["id"].intValue
            main = climate["main"].stringValue
            icon = climate["icon"].stringValue
            description = climate["description"].stringValue
        }
        
        // Build weather
        return Weather(city: city!, currentTemp: temperature!, conditions: description)
        
    }
}