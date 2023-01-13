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
    
    let service = Service()
    
    // MARK: - Properties
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchResults = [String]()
    var completionSaveCity: ((String) -> ())?
    
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
    
//        let request = Request(
//            endPoint: .findPlace,
//            queryParameters: [
//                URLQueryItem(name: "fields", value: "formatted_address"),
//                URLQueryItem(name: "input", value: city),
//                URLQueryItem(name: "inputtype", value: "textquery"),
//                URLQueryItem(name: "key", value: "AIzaSyD5w9hIjcghZtugzS_JW9Qhb7T1EoxOxJw")
//            ]
//        )
        
        self.searchResults = []
        let city = try? await service.execute(.searchCity, expecting: City.self)
        
        await MainActor.run { [weak self] in
            self?.searchResults.append(city?.candidates.first?.address ?? "")
            self?.tableView.reloadData()
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        guard text.count >= Constants.textCountSearch else { return }
        
        DispatchQueue.main.async { [weak self] in
            Task {
                await self?.requestSearch(city: text)
            }
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
        
        cell.textLabel?.text = searchResult
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let nameCity = searchResults[indexPath.row]
        self.getCity(city: nameCity)
    }
    
    private func getCity(city: String) {
        completionSaveCity?(city)
        self.navigationController?.popViewController(animated: true)
    }
}
