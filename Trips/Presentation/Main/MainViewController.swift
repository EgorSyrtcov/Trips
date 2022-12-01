//
//  Main.swift
//  Trips
//
//  Created by Egor Syrtcov on 29.11.22.
//

import UIKit

class MainViewController: UIViewController {
    
    private var trips = [
        TripModel(title: "Bali"),
        TripModel(title: "Mexico"),
        TripModel(title: "Russian"),
        TripModel(title: "Ukraine")
    ]

    let tableView = UITableView()
    
    lazy var addButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "addButton.png"), for: .normal)
        button.tintColor = .orange
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupConstraints()
        setupTableView()
    }
    
    private func setup() {
        self.navigationItem.title = "My trips"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        tableView.dataSource = self
    }
    
    private func setupTableView() {
        tableView.registerClassForCell(MainCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 180
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("!!!!!!")
//        let detailVC = DetailVC()
//        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainCell = tableView.dequeueReusableCell(for: indexPath)
        let trip = trips[indexPath.row]
        cell.setupTrip(trip)
        return cell
    }
}
