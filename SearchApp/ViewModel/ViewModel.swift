//
//  ViewModel.swift
//  SearchApp
//
//  Created by Saiteja Alle on 9/4/20.
//  Copyright © 2020 Saiteja Alle. All rights reserved.
//

import Foundation
import UIKit.UIImage

public class ViewModel {
    
    var productsData:Box<Products?> = Box(nil)
    var error:Box<APIError?> = Box(nil)

    func fetchProductsData(searchText: String?, page: Int = 1) {
        APIClient.productData(searchText: searchText!, page: page) { (products, error) in
            guard let productData = products else {
                return
            }
            self.productsData.value = productData
            self.error.value = error
        }
    }
    
}
