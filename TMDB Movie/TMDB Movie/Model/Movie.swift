//
//  Movie.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Movie {
    var poster_path  : String?
    var id: Int = 0
    var backdrop_path : String?
    var title : String?
    var vote_average: Int = 0
    var overview : String?
    var release_date : String?
    
    static func with(json: JSON) -> Movie? {
        var movie = Movie()
        
        if json["id"].exists() {
            movie.id = json["id"].intValue
        }
        if json["vote_average"].exists() {
            movie.vote_average = json["vote_average"].intValue
        }
        if json["title"].exists() {
            movie.title = json["title"].string
        }
        
        if json["poster_path"].exists() {
            movie.poster_path = json["poster_path"].string
        }
        
        if json["backdrop_path"].exists() {
            movie.backdrop_path = json["backdrop_path"].string
        }
        
        if json["overview"].exists() {
            movie.overview = json["overview"].string
        }
        
        if json["release_date"].exists() {
            movie.release_date = json["release_date"].string
        }
        
        return movie
    }
}
