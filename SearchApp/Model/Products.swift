//
//  Products.swift
//  SearchApp
//
//  Created by Saiteja Alle on 9/4/20.
//  Copyright © 2020 Saiteja Alle. All rights reserved.
//

import Foundation

struct Products: Decodable {
  let data: [Product]?
  let meta: MetaData?
}

struct Product: Decodable {
    let images:[ProductImages]
    let name: String
    let seller: Seller
    let price: Double
    
    struct Seller: Decodable {
        let username: String
    }
    
    struct ProductImages: Decodable {
        let id: Int
        let url: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case url = "thumb_url"
        }
    }
}

struct MetaData: Decodable {
    let paging: Paging
    
    struct Paging: Decodable {
        let pageSize:Int
        let page:Int
        let hasNextPage:Bool
        
        enum CodingKeys: String, CodingKey {
            case pageSize = "page_size"
            case page = "page"
            case hasNextPage = "has_next_page"
        }
    }

}

