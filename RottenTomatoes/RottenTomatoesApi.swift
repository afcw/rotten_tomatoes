//
//  RottenTomatoesApi.swift
//  RottenTomatoes
//
//  Created by Wanda Cheung on 9/23/14.
//  Copyright (c) 2014 Wanda Cheung. All rights reserved.
//

import UIKit

struct RottenTomatoesApi {
  static var API_BASE = "http://api.rottentomatoes.com/api/public/v1.0"
  static var API_KEY = "qnsmegrunuw43cgmsx8kuuyg"
  
  static func getEndpointURL(endpoint: RottenTomatoesEndpoint) -> NSURL {
    return NSURL(string: "\(API_BASE)\(endpoint.toRaw())?limit=50&apikey=\(API_KEY)")
  }
}

enum RottenTomatoesEndpoint: NSString {
  case BoxOffice = "/lists/movies/box_office.json"
  case TopRentals = "/lists/dvds/top_rentals.json"
}

