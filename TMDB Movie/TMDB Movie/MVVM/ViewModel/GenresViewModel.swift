//
//  GenresViewModel.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit
import RxCocoa
import RxSwift

protocol GenresViewModelDelegate: class {
    func onLoading()
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

class GenresViewModel {
    let api: APIConnector
    let disposeBag = DisposeBag()
    var genres = [Genre]()
    private let refreshStream = PublishSubject<Void>()
    private var currentPage = 1
    private var total = 0
    var delegate : GenresViewModelDelegate!
    
    init(apiConnector: APIConnector = APIConnector.instance) {
        self.api = apiConnector
        setupStream()
    }
    
    func startStream(page : Int = 0){
        refreshStream.onNext(())
    }
    
    func setupStream() {
        refreshStream
            .do(onNext : { _ in
                self.delegate.onLoading()
            })
            .filter{
                return true
            }
            .flatMap { url in
                self.api.getListGenres()
            }
            .do( onNext : { items in
                self.genres.append(contentsOf: items)
                    self.delegate.onFetchCompleted(with: .none)
            }, onError : {
                errorType in
                self.delegate.onFetchFailed(with: errorType.localizedDescription)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func getGenresCount() -> Int {
        return genres.count
    }
    
//    private func calculateIndexPathsToReload(from newGenres: [Genre]) -> [IndexPath] {
//      let startIndex = genres.count - newGenres.count
//      let endIndex = startIndex + newGenres.count
//      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
//    }
    
}
