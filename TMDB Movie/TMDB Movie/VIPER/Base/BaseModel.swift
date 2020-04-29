//
//  BaseModel.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseModel: Mappable {
    
    init() {}
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
}

