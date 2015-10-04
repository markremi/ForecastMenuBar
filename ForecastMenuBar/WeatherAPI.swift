//
//  WeatherAPI.swift
//  ForecastMenuBar
//
//  Created by Mark Remi on 10/3/15.
//  Copyright © 2015 Mark Remi. All rights reserved.
//

import Foundation

// Basic Weather object.
struct Weather {
    var city: String
    var currentTemp: Float
    var conditions: String
}

class WeatherAPI {
    
    // Base url for Openweathermap.
    let URL = "http://api.openweathermap.org/data/2.5/weather?units=imperial&q="
    
    func getWeatherByCity(city: String) {
        
        // Set up session.
        let session = NSURLSession.sharedSession()
        let requestURL = NSURL(string: URL + city)
        let task = session.dataTaskWithURL(requestURL!)
    }
    
    
    func extractJSON(data: NSData) -> Weather? {
        
//        typealias JSONDict = [String:AnyObject]
//        
//        var json: NSDictionary
//        
//        json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
//        
//        if let items = json["items"] as? NSArray {
//            
//            // Loop through items here...
//                var mainList = json["main"] as! JSONDict
//                var weatherList = json["weather"] as! JSONDict
//                var name = json["name"]as! String
//                
//            
//        }
        
        return Weather(city: "",currentTemp: 1,conditions: "")
        
    }
 
    
    
//     Sample JSON weather api
//    {
//        "coord": {
//        "lon": -122.33,
//        "lat": 47.61
//    },
//    "weather": [{
//        "id": 802,
//        "main": "Clouds",
//        "description": "scattered clouds",
//        "icon": "03d"
//    }],
//    "base": "cmc stations",
//    "main": {
//        "temp": 63.48,
//        "pressure": 1016,
//        "humidity": 42,
//        "temp_min": 57,
//        "temp_max": 66.99
//    },
//    "wind": {
//        "speed": 6.7,
//        "deg": 300
//    },
//    "clouds": {
//        "all": 40
//    },
//    "dt": 1442961164,
//    "sys": {
//        "type": 1,
//        "id": 2949,
//        "message": 0.0165,
//        "country": "US",
//        "sunrise": 1442930230,
//        "sunset": 1442973924
//    },
//    "id": 5809844,
//    "name": "Seattle",
//    "cod": 200
//    }
    
    
}