//
//  GenreService.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

// MARK: GenreService: GenreServiceInterface

class GenreService: GenreServiceInterface {
    let url = "https://api.themoviedb.org/3"
    let API_KEY = "2dd8a088e8109b84d3d3f48a11668e7e"
    
    func getGenres() -> Observable<[VGenre]> {
        let url = Constant.GENRES.BASE_URL
        let params = Constant.GENRES.buildGeneralParameters()
        
        return requestJSON(.get, url, parameters: params)
            .debug()
            .mapObject(type: GenreResult.self)
            .map({ (genreResult) -> [VGenre] in genreResult.genres ?? [] })
    }
}
