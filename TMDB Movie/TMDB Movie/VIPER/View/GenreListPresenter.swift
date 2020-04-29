//
//  GenreListPresenter.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import Foundation
import RxSwift

class GenreListPresenter {
    
    // MARK: Properties
    
    var view: GenreListViewInterface?
    var interactor: GenreListInteractorInputInterface?
    var wireframe: GenreListWireframeInterface?
    
    var genres: [VGenre] = []
    
    init(view: GenreListViewInterface?) {
        self.view = view
    }
    
}

// MARK: UIView Lifecycle

extension GenreListPresenter: GenreListPresenterInterface {
    func didSelectGenre(_ genre: VGenre) {
        
    }
    
    func viewDidLoad() {
        self.view?.setupUI()
        self.loadGenres()
    }
    
    func viewDidDisappear(_ animated: Bool) {
        self.interactor?.outputFinished()
    }
    
    func viewWillAppear(_ animated: Bool) {}
    
    func viewWillDisappear(_ animated: Bool) {}
}

// MARK: Methods

extension GenreListPresenter {
    
    func loadGenres() {
        interactor?.loadGenres()
    }
}

// MARK: GenresInteractorFeedback

extension GenreListPresenter: GenreListInteractorOutputInterface {
    
    func genresDidFetch(_ genres: [VGenre]) {
        self.genres = genres
        
        self.view?.showGenres(with: genres)
    }
    
    func genresDidError(_ error: DefaultError) {
        self.view?.onError(message: error.err)
    }
}

