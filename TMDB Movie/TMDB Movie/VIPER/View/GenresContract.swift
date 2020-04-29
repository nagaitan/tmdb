//
//  GenresContract.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//


import UIKit

protocol GenreListViewInterface: BaseViewInterface {
    
    var presenter: GenreListPresenterInterface? { get set }
    
    func showGenres(with genres: [VGenre])
}

protocol GenreListPresenterInterface: BasePresenterInterface {
    
    var view: GenreListViewInterface? { get set }
    var interactor: GenreListInteractorInputInterface? { get set }
    var wireframe: GenreListWireframeInterface? { get set }
    
    func loadGenres()
}

protocol GenreListInteractorInputInterface: BaseInteractorInterface {
    var output: GenreListInteractorOutputInterface? { get set }

    func loadGenres()
}

protocol GenreListInteractorOutputInterface {
    
    func genresDidFetch(_ genres: [VGenre])
    
    func genresDidError(_ error: DefaultError)
}

protocol GenreListWireframeInterface: BaseWireframeInterface {
    static func buildModule() -> UIViewController
}

