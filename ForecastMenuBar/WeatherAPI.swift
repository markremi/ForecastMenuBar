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
let BASE_URL : String = "http://api.openweathermap.org/data/2.5/weather?units=imperial"
let ICON_URL : String = "http://openweathermap.org/img/w/"
let ICON_EXTENSION : String = ".png"
let ICON_SIZE: CGFloat = 30

/// App id.
let APP_ID = "fecc856e95228926c6d5e20b245bde91"

/** 
    Basic Weather object.
    - Parameters:
        - city
        - currentTemp: Current temperature.
        - conditions: Current weather description.
*/
struct Weather {
    var city: String
    var currentTemp: Float
    var conditions: String
    var icon: String
    var httpCode: Int
}

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
            
            // Handle error.
            if (error != nil) {
                self.callback(result: "", error: error?.localizedDescription)
            }
            
            // Using the completionHandler override so we can get this value synchronously (like the rest of the applicaiton)
            completionHandler(data, error)
        }
        
        sessionTask.resume()
        return sessionTask
    }
    
    typealias CallbackBlock = (result: String, error: String?) -> ()
    var callback: CallbackBlock = {
        (resultString, error) -> Void in
        if error == nil {
            print(resultString)
        } else {
            print(error)
        }
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
    
    /**
        Transform NSData to JSON, then parse value to Weather struct.
    
        - Parameters:
            - data: JSON data.
    */
    func parseJSON(data: NSData) -> Weather? {
        
        let json = JSON(data: data)
        if (json != nil) {
            print("JSON value : ")
            print(json)
        } else {
            print("JSON is nil!")
        }

       
        let httpCode = json["cod"].intValue

        
        // List of weather codes
        var id:Int
        var main : String
        var icon : String = ""
        var description : String = ""
        var temperature : Float = 0
        var city : String = ""
        
        if (httpCode == 200) {
            
            city = json["name"].string!
            temperature = json["main"]["temp"].float!
            
            // Lets grab all the JSON values here.
            for climate in json["weather"].arrayValue {
                id = climate["id"].intValue
                main = climate["main"].stringValue
                icon = climate["icon"].stringValue
                description = climate["description"].stringValue
            }
        }
        
        // Build weather
        return Weather(city: city, currentTemp: temperature, conditions: description, icon: icon, httpCode: httpCode)
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
}