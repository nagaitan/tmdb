//
//  Review.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Review {
    var author : String?
    var id : String?
    var content : String?
    var url : String?
    static func with(json: JSON) -> Review? {
        var review = Review()
        
        if json["id"].exists() {
            review.id = json["id"].string
        }
        if json["author"].exists() {
            review.author = json["author"].string
        }
        if json["key"].exists() {
            review.content = json["content"].string
        }
        if json["url"].exists() {
            review.url = json["url"].string
        }
        return review
    }
}
