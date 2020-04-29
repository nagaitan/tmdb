//
//  GenreListIntractor.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//


import Foundation
import RxSwift

// MARK: GenreListIntractor: BaseInteractor

class GenreListInteractor: BaseInteractor {
    let service: GenreServiceInterface
    
    var output: GenreListInteractorOutputInterface?
    
    init(output: GenreListInteractorOutputInterface?) {
        self.output = output
        self.service = GenreService()
    }
    
}

// MARK: GenresInteractorInputInterface - Output lifecycle Methods

extension GenreListInteractor: GenreListInteractorInputInterface {
    
    func outputDidLoad() {}
    
    func outputFinished() {
        disposibles.dispose()
        self.output = nil
    }
}

// MARK: GenresInteractorInputInterface - Fetch methods

extension GenreListInteractor {
    func loadGenres() {
        print("Get Genres")
        add(service.getGenres()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (genres) in
                self.output?.genresDidFetch(genres)
            }, onError: { (error) in
                self.output?.genresDidError(DefaultError(_err: "No Genre Found!"))
            })
        )
    }
}

