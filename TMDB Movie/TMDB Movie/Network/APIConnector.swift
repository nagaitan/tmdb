//
//  APIConnector.swift
//  TMDB Movie
//
//  Created by Adi Wibowo on 26/04/20.
//  Copyright © 2020 Adi Wibowo. All rights reserved.
//


import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

struct APIResponse {
    var code: Int
    var message: String
    var result: JSON
    
    init(code: Int, message: String, result: JSON) {
        self.code = code
        self.message = message
        self.result = result
    }
}

class APIConnector: NSObject {
    static let instance = APIConnector()
    let manager: APIManager
    let homeURLString : String
    final let API_KEY = "2dd8a088e8109b84d3d3f48a11668e7e"
    
    final let URL_GENRES = "/genre/movie/list"
    
    override init() {
        homeURLString = "https://api.themoviedb.org/3"
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        manager = APIManager(configuration: configuration)
        super.init()
    }
    
    func getListGenres() -> Observable<([Genre])>{
        let parameters: [String: Any] = [
            "api_key": API_KEY
        ]
        let request = manager.request(homeURLString + URL_GENRES, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
        return request.rx_JSON()
            .mapJSONResponse()
            .map { response in
                if response.code != 200 {
                    throw NSError(domain: "APIErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
                    var genres = [Genre]()
                    for gen in response.result["genres"].arrayValue {
                        if let catItem = Genre.with(json: gen) {
                            genres.append(catItem)
                        }
                    }
                
                    return (genres)
        }
    }
    
}

class APIManager: SessionManager {
    
    override func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?) -> DataRequest {
        var overridedParameters = [String : AnyObject]()
        let overridedHeaders = [String: String]()
        
        if let parameters = parameters {
            overridedParameters = parameters as [String : AnyObject]
        }
        
        return super.request(url, method: method, parameters: overridedParameters, encoding: encoding, headers: overridedHeaders)
    }
    
}

extension Observable {
    func mapJSONResponse() -> Observable<APIResponse> {
        return map { (item: Element) -> APIResponse in
            guard let json = item as? JSON else {
                fatalError("Not a JSON")
            }
            let code = 200;
            let message = "";
            let result = json;

            return APIResponse(code: code, message: message, result: result)
        }
    }
}


extension DataRequest{
    func rx_JSON(options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<JSON> {
        let observable = Observable<JSON>.create { observer in
            self.responseJSON(options: options) { response in
                if let error = response.result.error {
                    _ = String(data: response.data!, encoding: String.Encoding.utf8)
                    observer.onError(error)
                } else if let value = response.result.value {
                    let json = JSON(value)
                    if let error = json.error {
                        observer.onError(error)
                    } else {
                        observer.onNext(json)
                        observer.onCompleted()
                    }
                    
                } else {
                    observer.onError(NSError(domain: "APIErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown Error"]))
                }
            }
            return Disposables.create(with: self.cancel)
        }
        return Observable.deferred { return observable }
    }
}


