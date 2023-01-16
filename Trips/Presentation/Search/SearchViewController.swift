//
//  SearchViewController.swift
//  Trips
//
//  Created by Egor Syrtcov on 26.12.22.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - Constants
    private struct Constants {
        static let textCountSearch = 3
    }
    
    private var isRequest = false
    
    let service = Service()
    
    // MARK: - Properties
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchResults = [City]()
    var completionSaveCity: ((City) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupTableView()
        setupNavigationController()
        setupSearchController()
        setupUI()
    }
    
    private func setupTableView() {
        tableView.registerClassForCell(UITableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Search cities"
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func requestSearch(city: String) async {
        
        self.searchResults = []
        let city = try? await service.execute(.searchRequest(city: city), expecting: CityResponse.self)

        await MainActor.run { [weak self] in
            self?.searchResults = city?.сities ?? []
            self?.tableView.reloadData()
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        guard text.count >= Constants.textCountSearch else { return }
        
        Task {
            await requestSearch(city: text)
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.textLabel?.text = searchResult.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCity = searchResults[indexPath.row]
        self.getCity(city: selectedCity)
    }
    
    private func getCity(city: City) {
        completionSaveCity?(city)
        self.navigationController?.popViewController(animated: true)
    }
}
