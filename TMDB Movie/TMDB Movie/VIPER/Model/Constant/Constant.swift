//
//  Constant.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import Foundation
struct Constant {

    static let API_KEY       = "2dd8a088e8109b84d3d3f48a11668e7e"
    static let GLOBAL_URL       = "https://api.themoviedb.org/3"
    
    struct GENRES {
        static let BASE_URL  = "\(GLOBAL_URL)/genre/movie/list"
        
        static func buildGenreUrl() -> String {
            return BASE_URL
        }
        
        static func buildGeneralParameters() -> [String : String] {
            return [
                "api_key" : API_KEY
            ]
        }
    }
}
