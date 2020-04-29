//
//  GenreListWireframe.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 29/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//

import UIKit
// MARK: build's Module
class GenreListWireframe: GenreListWireframeInterface {
    weak var viewController: UIViewController?
}

extension GenreListWireframe {
    
    static func buildModule() -> UIViewController {
        let view = StoryboardManager.instance.genreList.instantiateViewController(identifier: "GenreListVC") as GenreListController
        return build(view)
    }
    
    static func buildModuleFromUINavigation() -> UIViewController {
        let navigationController = StoryboardManager.instance.genreList.instantiateViewController(identifier: "GenreListVCNav") as UINavigationController
        let view = navigationController.viewControllers.first as! GenreListController
        _ = build(view)
        return navigationController
    }
    
    private static func build(_ view: GenreListController?) -> UIViewController  {
        let wireframe = GenreListWireframe()    
        let presenter = GenreListPresenter(view: view)
        let interactor = GenreListInteractor(output: presenter)
        
        view?.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        
        interactor.output = presenter
        wireframe.viewController = view
        
        return view!
    }
}

