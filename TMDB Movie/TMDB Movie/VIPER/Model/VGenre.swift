//
//  VGenre.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import Foundation
import ObjectMapper

class VGenre : BaseModel {
    var id : Int?
    var name : String?

    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

class GenreResult : BaseModel {
    var genres : [VGenre]?
    
    override func mapping(map: Map) {
        genres <- map["genres"]
    }
}

