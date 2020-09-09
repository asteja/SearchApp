//
//  MasterViewController.swift
//  SearchApp
//
//  Created by Saiteja Alle on 9/4/20.
//  Copyright © 2020 Saiteja Alle. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = ViewModel()
    var products:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSearchController()
        self.setUpTableView()
        viewModel.productsData.bind { [weak self] productsData in
            DispatchQueue.main.async {
                if let products = productsData?.data {
                    self?.products.append(contentsOf: products)
                    self?.tableView.reloadData()
                }
            }
        }
        
        viewModel.error.bind { [weak self] error in
            guard let error = error else {
                return
            }
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert", message: error.rawValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
        viewModel.fetchProductsData(searchText: "Nike Bag")
    }
    
    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Text"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        definesPresentationContext = true
    }
    
    private func setUpTableView() {
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}

// MARK: - Table View

extension MasterViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductTableViewCell
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: products[indexPath.row].name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]));
        text.append(NSAttributedString(string: "\nSeller: \(products[indexPath.row].seller.username)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]))
        cell.desc.attributedText = text
        cell.price.text = "$\(products[indexPath.row].price)"
        cell.productImageView.loadImageUsingCache(withUrl: products[indexPath.row].images.first!.url)
        cell.layoutIfNeeded()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.addLoading(indexPath) {[weak self] in
            guard let weakSelf = self else {
                return
            }
            if let productsData = weakSelf.viewModel.productsData.value, let meta = productsData.meta {
                weakSelf.viewModel.fetchProductsData(searchText: weakSelf.searchController.searchBar.text, page: meta.paging.page + 1)
            }
            tableView.stopLoading()
        }
    }
    
}

// MARK: - Search Bar

extension MasterViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        self.products = []
        self.viewModel.fetchProductsData(searchText: text)
    }
    
}

