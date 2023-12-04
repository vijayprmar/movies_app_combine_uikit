//
//  MovieListViewModel.swift
//  MoviesAppUIKit
//
//  Created by Vijay Parmar on 01/12/23.
//

import Foundation
import Combine


class MovieListViewModel{
    
    @Published private(set) var movies:[Movie] = []
    private var cancellable:Set<AnyCancellable> = []
    private let httpClient:HttpClient
    @Published var loadingCompleted :Bool = false
    
    init(httpClient:HttpClient){
        self.httpClient = httpClient
    }
    
    func loadMovies(search:String){
        httpClient.fetchMovies(search: search)
            .sink { [weak self] completion in
                switch completion{
                case .finished:
                    print("finished")
                    self?.loadingCompleted = true
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }.store(in: &cancellable)

    }
    
}
