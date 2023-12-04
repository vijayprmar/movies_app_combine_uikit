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
    
    private var searchSubject = CurrentValueSubject<String,Never>("")
    
    init(httpClient:HttpClient){
        self.httpClient = httpClient
        setupSearchPublisher()
    }
    
    private func setupSearchPublisher(){
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink {[weak self] searchText in
            self?.loadMovies(search: searchText)
        }.store(in: &cancellable)
    }
    
    func setSearchText(_ searchText:String){
        searchSubject.send(searchText)
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
