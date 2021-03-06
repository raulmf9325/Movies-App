//
//  Service.swift
//  Movies
//
//  Created by Raul Mena on 1/4/19.
//  Copyright © 2019 Raul Mena. All rights reserved.
//

import UIKit

class Service{
    
    static let shared = Service()
    
    func fetchJSON(query: String, completion: @escaping ([Movie]?, Int) -> ()){
        guard let url = URL(string: query) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil, 0)
                return
            }
            do{
                let website = try JSONDecoder().decode(Website.self, from: data)
                let movies = website.results
                let totalNumberOfPages = website.total_pages
                DispatchQueue.main.async {
                    completion(movies, totalNumberOfPages ?? 0)
                }
            } catch let jsonError{
                print("Error while parsing JSON \n", jsonError)
            }
            }.resume()
    }
    
    // MARK: fetch featured movies
    func fetchFeatured(_ page: Int, completion: @escaping ([Movie]?, Int) -> ()){
        let URLString = "https://api.themoviedb.org/3/discover/movie?api_key=68ef98a4affa652b311088086fb922db&lsort_by=popularity.desc&page=\(page)&region=US&language=en-US"
        fetchJSON(query: URLString) { (movies, totalNumberOfPages) in
            DispatchQueue.main.async {
                completion(movies, totalNumberOfPages)
            }
        }
    }
    
    // MARK: fetch similar movies
    func fetchSimilarMovies(movieID: Int, completion: @escaping ([Movie]?, Int) -> ()){
        let URLString = "https://api.themoviedb.org/3/movie/\(movieID)/similar?api_key=68ef98a4affa652b311088086fb922db&language=en-US&page=1"
        fetchJSON(query: URLString) { (movies, totalNumberOfPages) in
            DispatchQueue.main.async {
                completion(movies, totalNumberOfPages)
            }
        }
    }
    
    // MARK: fetch upcoming movies
    func fetchUpcoming(page: Int, completion: @escaping ([Movie]?, Int) -> ()){
        let URLString = "https://api.themoviedb.org/3/movie/upcoming?api_key=68ef98a4affa652b311088086fb922db&language=en-US&page=\(page)&region=US"
        fetchJSON(query: URLString) { (movies, totalNumberOfPages) in
            DispatchQueue.main.async {
                completion(movies, totalNumberOfPages)
            }
        }
    }
    
    // MARK: In theaters
    func fetchInTheaters(page: Int, completion: @escaping ([Movie]?, Int) -> ()){
        let URLString = "https://api.themoviedb.org/3/movie/now_playing?api_key=68ef98a4affa652b311088086fb922db&language=en-US&page=\(page)&region=US"
        fetchJSON(query: URLString) { (movies, totalNumberOfPages) in
            DispatchQueue.main.async {
                completion(movies, totalNumberOfPages)
            }
        }
    }
    
    // MARK: fetch movies from search
    func fetchMoviesWithQuery(query: String, completion: @escaping ([Movie]?, Int) -> ()){
        let URLString = "https://api.themoviedb.org/3/search/movie?api_key=68ef98a4affa652b311088086fb922db&query=\(query)"
        fetchJSON(query: URLString) { (movies, totalNumberOfPages)  in
            DispatchQueue.main.async {
                completion(movies, totalNumberOfPages)
            }
        }
    }
    
    // MARK: fetch movie duration
    func fetchMovieDuration(movieID: Int, completion: @escaping (Int?) -> ()){
        let jsonURLString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=68ef98a4affa652b311088086fb922db&append_to_response=credits"
        guard let url = URL(string: jsonURLString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {return}
            
            do{
                let duration = try JSONDecoder().decode(runtime.self, from: data)
                
                DispatchQueue.main.async(execute: {
                    completion(duration.runtime)
                })
                
            } catch let jsonError{
                print("Error while parsing JSON \n", jsonError)
            }
            }.resume()
    }
    
    // MARK: fetch movie genres
    func fetchMovieGenres(movieID: Int, completion: @escaping ([genre]?) -> ()){
        let jsonURLString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=68ef98a4affa652b311088086fb922db&append_to_response=credits"
        guard let url = URL(string: jsonURLString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {return}
            
            do{
                let genreNames = try JSONDecoder().decode(genres.self, from: data)
                
                DispatchQueue.main.async(execute: {
                    completion(genreNames.genres)
                })
                
            } catch let jsonError{
                print("Error while parsing JSON \n", jsonError)
            }
            }.resume()
    }
    
    // MARK: fetch movie cast
    func fetchMovieCast(movieID: Int, completion: @escaping ([Cast]?) -> ()){
        let jsonURLString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=68ef98a4affa652b311088086fb922db&append_to_response=credits"
        guard let url = URL(string: jsonURLString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {return}
            
            do{
                let casting = try JSONDecoder().decode(cast.self, from: data)
                
                DispatchQueue.main.async(execute: {
                    if casting.credits == nil || casting.credits?.cast == nil || casting.credits?.cast?.count == 0{
                        print("Null cast for --> \(movieID)")
                    }
                    completion(casting.credits?.cast)
                })
                
            } catch let jsonError{
                print("Error while parsing JSON \n", jsonError)
            }
            }.resume()
    }
    
    // MARK: fetch movie trailer youtube ID
    func fetchMovieTrailerURL(movieID: Int, completion: @escaping ([trailers]?) -> ()){
        let jsonURLString = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=68ef98a4affa652b311088086fb922db"
        guard let url = URL(string: jsonURLString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {return}
            
            do{
                let trailers = try JSONDecoder().decode(trailersResults.self, from: data)
                
                DispatchQueue.main.async(execute: {
                    completion(trailers.results)
                })
                
            } catch let jsonError{
                print("Error while parsing JSON \n", jsonError)
            }
            }.resume()
    }
}

struct Website: Decodable{
    var total_pages: Int?
    var results: [Movie]?
}

struct Movie: Decodable{
    var id: Int?
    var title: String?
    var vote_average: Double?
    var poster_path: String?
    var backdrop_path: String?
    var genre_ids: [Int]?
    var overview: String?
    var release_date: String?
}

struct genres: Decodable{
    var genres: [genre]?
}

struct runtime: Decodable{
    var runtime: Int?
}

struct cast: Decodable{
    var credits: Credits?
     var title: String?
}

struct genre: Decodable{
    var id: Int?
    var name: String?
}

struct Credits: Decodable{
    var cast: [Cast]?
}

struct Cast: Decodable{
    var character: String?
    var name: String?
    var profile_path: String?
}

struct trailersResults: Decodable{
    var results: [trailers]?
}

struct trailers: Decodable{
    var key: String?
}
