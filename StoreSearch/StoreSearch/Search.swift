//
//  Search.swift
//  StoreSearch
//
//  Created by Admin on 09.10.2020.
//  Copyright © 2020 alec. All rights reserved.
//

import Foundation

typealias SearchComplete = (Bool) -> Void

class Search {
    var searchResults: [SearchResult] = []
    var hasSearched = false
    var isLoading = false
    
    private var dataTask: URLSessionDataTask? = nil
    
    func performSearch(for text: String, category: Int, completion: @escaping SearchComplete) {
        if !text.isEmpty {
            dataTask?.cancel()

            isLoading = true
            hasSearched = true
            searchResults = []

            let url = iTunesURL(searchText: text, category: category)
            let session = URLSession.shared

            dataTask = session.dataTask(with: url) { [weak self] data, response, error in
                if let weakSelf = self {
                    var success = false
                    
                    if let error = error as NSError?, error.code == -999 { return }
                    
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        if let data = data {
                            weakSelf.searchResults = weakSelf.parse(data: data)
                            weakSelf.searchResults.sort(by: <)

                            print("Success!")
                            weakSelf.isLoading = false
                            
                            success = true
                        }
                    }
                    
                    if !success {
                        weakSelf.hasSearched = false
                        weakSelf.isLoading = false
                    }
                    
                    DispatchQueue.main.async {
                        completion(success)
                    }
                }
            }
            
            dataTask?.resume()
        }
    }
    
    // MARK: - Private Methods
    
    private func iTunesURL(searchText: String, category: Int) -> URL {
        let kind: String
        switch category {
            case 1:  kind = "musicTrack"
            case 2:  kind = "software"
            case 3:  kind = "ebook"
            default: kind = ""
        }
        
        // Encode invalid characters for URL
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?term=\(encodedText)&limit=200&entity=\(kind)"
        let url = URL(string: urlString)
        
        return url!
    }
    
    private func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
}
