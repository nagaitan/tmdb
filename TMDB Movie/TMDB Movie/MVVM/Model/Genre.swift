//
//  Genre.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Genre {
    var name : String?
    var id : Int = 0
    
    static func with(json: JSON) -> Genre? {
        var genre = Genre()
        
        if json["id"].exists() {
            genre.id = json["id"].intValue
        }
        if json["name"].exists() {
            genre.name = json["name"].string
        }
        return genre
    }
    
}
