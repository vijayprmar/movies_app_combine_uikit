//
//  HttpClient.swift
//  MoviesAppUIKit
//
//  Created by Vijay Parmar on 01/12/23.
//

import Foundation
import Combine

enum NetworkError:Error{
    case badUrl
    
}


class HttpClient{
    
    func fetchMovies(search:String)->AnyPublisher<[Movie],Error>{
        
        guard let encodedSearch = search.urlEncoded else{
            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
            
        }
        
        let url = URL(string: "https://www.omdbapi.com/?s=\(encodedSearch)&page=2&apiKey=564727fa")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieRresponnse.self, decoder: JSONDecoder())
            .map(\.Search)
            .receive(on: DispatchQueue.main)
            .catch { error->AnyPublisher<[Movie],Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }.eraseToAnyPublisher()
        
    }
    
    
}
