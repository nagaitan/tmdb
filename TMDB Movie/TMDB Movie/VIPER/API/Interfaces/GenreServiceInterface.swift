//
//  GenreServiceInterface.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import RxSwift
import RxAlamofire

// MARK: GenreServiceInterface

protocol GenreServiceInterface {
    func getGenres() -> Observable<[VGenre]>
}

