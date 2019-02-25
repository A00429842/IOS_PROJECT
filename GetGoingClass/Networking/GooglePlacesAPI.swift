//
//  GooglePlacesAPI.swift
//  GetGoingClass
//
//  Created by shaunyan on 2019-01-21.
//  Copyright © 2019 SMU. All rights reserved.
//

import Foundation
import CoreLocation

class GooglePlacesAPI {

    class func requestPlaces(_ query: String, radius: Float, opennow: Bool?, completion: @escaping(_ status: Int, _ json: [String: Any]?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.textPlaceSearch

        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "radius", value: "\(Int(radius))"),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        
        /* if users do not turn on "open now", we regard they want the whole result by default,
             while not in the staus of "close now".
        */
        if opennow == true {
            urlComponents.queryItems?.append(URLQueryItem(name: "opennow", value: opennow?.description))
        }
        
        if let url = urlComponents.url {
            NetworkingLayer.getRequest(with: url, timeoutInterval: 500) { (status, data) in

                if let responseData = data,
                    let jsonResponse = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] {
                    completion(status, jsonResponse)
                } else {
                    completion(status, nil)
                }
            }
        }
    }

    class func requestPlacesNearby(for coordinate: CLLocationCoordinate2D, radius: Float, _ query: String?,rankby: String,opennow: Bool?, completion: @escaping(_ status: Int, _ json: [String: Any]?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.nearbySearch
        urlComponents.queryItems = [
            URLQueryItem(name: "location", value: "\(coordinate.latitude),\(coordinate.longitude)"),
            URLQueryItem(name: "key", value: Constants.apiKey),
            URLQueryItem(name: "rankby", value: rankby)
        ]

        // when rankby == "distance", radius can not be included
        if rankby == "prominence" {
            urlComponents.queryItems?.append(URLQueryItem(name: "radius", value: "\(Int(radius))"))
        }
        
        if let keyword = query {
            urlComponents.queryItems?.append(URLQueryItem(name: "keyword", value: keyword))
        }
        
        /* if users do not turn on "open now", we regard they want the whole result by default,
             while not in the staus of "close now".
            */
        if opennow == true {
            urlComponents.queryItems?.append(URLQueryItem(name: "opennow", value: opennow?.description))
        }

        if let url = urlComponents.url {
            print(url)

            NetworkingLayer.getRequest(with: url, timeoutInterval: 500) { (status, data) in

                if let responseData = data,
                    let jsonResponse = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] {
                    completion(status, jsonResponse)
                } else {
                    completion(status, nil)
                }
            }
        }
    }
    
    class func requestPlaceDetail(_ placeid: String, completion: @escaping(_ status: Int, _ json: [String: Any]?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.placeDetail
        
        urlComponents.queryItems = [
            URLQueryItem(name: "placeid", value: placeid),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        if let url = urlComponents.url {
            NetworkingLayer.getRequest(with: url, timeoutInterval: 500) { (status, data) in
                
                if let responseData = data,
                    let jsonResponse = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] {
                    completion(status, jsonResponse)
                } else {
                    completion(status, nil)
                }
            }
        }
    }
}
