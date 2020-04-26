//
//  Trailer.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Trailer {
    var name : String?
    var id : Int = 0
    var keyURl : String?
    
    static func with(json: JSON) -> Trailer? {
        var trailler = Trailer()
        
        if json["id"].exists() {
            trailler.id = json["id"].intValue
        }
        if json["name"].exists() {
            trailler.name = json["name"].string
        }
        if json["key"].exists() {
            trailler.keyURl = json["key"].string
        }
        return trailler
    }
    
}
