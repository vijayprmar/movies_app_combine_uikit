//
//  Movie.swift
//  MoviesAppUIKit
//
//  Created by Vijay Parmar on 01/12/23.
//

import Foundation

struct MovieRresponnse:Decodable{
    let Search:[Movie]
    let searchAll:Movie?
}

struct Movie:Decodable{
    
    let title: String
    let year:String
    
    private enum CodingKeys:String,CodingKey{
        case title = "Title"
        case year = "Year"
    }
    
    
}
