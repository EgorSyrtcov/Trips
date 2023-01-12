//
//  Main.swift
//  Trips
//
//  Created by Egor Syrtcov on 29.11.22.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var trips = [TripModel]()

    private let tableView = UITableView()
    private let transition = CircularTransition()
    private let service = LocalService()
    
    lazy var addButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "addButton"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupUI()
        setupTableView()
        loadModels()
    }
    
    private func setup() {
        self.navigationItem.title = "My trips"
        view.backgroundColor = .lightGray
    }
    
    private func setupTableView() {
        tableView.registerClassForCell(MainCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 180
    }
    
    private func loadModels() {
        trips = service.tripModels
        tableView.reloadData()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let addVC = AddTripViewController()
        navigationController?.delegate = self
        addVC.modalPresentationStyle = .custom
        addVC.transitioningDelegate = self
        addVC.completionSaveModel = { [weak self] in
            self?.loadModels()
        }
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            trips.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            service.removeItem(index: indexPath.item)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = trips[indexPath.row]
        let detailScreen = DetailTrip()
        detailScreen.setupTrip(trip)
        navigationController?.delegate = nil
        navigationController?.pushViewController(detailScreen, animated: true)
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension MainViewController: UIViewControllerTransitioningDelegate {
    
    private func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = addButton.center
        transition.circleColor = addButton.backgroundColor!
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = addButton.center
        transition.circleColor = addButton.backgroundColor!
        return transition
    }
}

extension MainViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = operation == .push ? .present : .dismiss
        transition.startingPoint = addButton.center
        transition.circleColor = operation == .pop ? .gray : .gray
        return transition
    }
}
