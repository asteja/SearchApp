//
//  APIClient.swift
//  SearchApp
//
//  Created by Saiteja Alle on 9/4/20.
//  Copyright © 2020 Saiteja Alle. All rights reserved.
//

import Foundation

enum APIError: String {
  case invalidResponse = "Invalid response"
  case noData = "No Data"
  case failedRequest = "Failed Request"
  case invalidData = "Invalid Data"
}

class APIClient {
    
    typealias ProductDataCompletion = (Products?, APIError?) -> ()
    private static let host = "api.staging.sidelineswap.com"
    private static let path = "/v1/facet_items"
    
    static func productData(searchText:String, page: Int, completion: @escaping ProductDataCompletion) {
        
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = path
        urlBuilder.queryItems = [
          URLQueryItem(name: "q", value: searchText),
          URLQueryItem(name: "page", value: "\(page)"),
        ]
        
        let url = urlBuilder.url!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          DispatchQueue.main.async {
            guard error == nil else {
              completion(nil, .failedRequest)
              return
            }
            
            guard let data = data else {
                completion(nil, .noData)
              return
            }
            
            guard let response = response as? HTTPURLResponse else {
              completion(nil, .invalidResponse)
              return
            }
            
            guard response.statusCode == 200 else {
              completion(nil, .failedRequest)
              return
            }
            
            do {
              let decoder = JSONDecoder()
              let productData: Products = try decoder.decode(Products.self, from: data)
              completion(productData, nil)
            } catch {
              completion(nil, .invalidData)
            }
          }
        }.resume()
        
    }
    
    static func loadImage(imageURL: String?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let urlString = imageURL, let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
              completionHandler(data, response, error)
            }
        }).resume()
    }
    
}
