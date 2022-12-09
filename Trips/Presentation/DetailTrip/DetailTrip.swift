//
//  DetailTrip.swift
//  Trips
//
//  Created by Egor Syrtcov on 9.12.22.
//

import UIKit

class DetailTrip: UIViewController {
    
    private let containerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Bali Trip!"
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 42)
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "12/12/12"
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupUI()
    }
    
    private func setup() {
        self.navigationItem.title = "Detail trip"
        view.backgroundColor = .lightGray
        
        // add shadow and cornerRadius
        containerView.layer.cornerRadius = 10
        containerView.setShadow()
    }
    
    private func setupUI() {
        view.addSubview(containerView)
        containerView.addSubview(profileImageView)
        profileImageView.addSubview(titleLabel)
        profileImageView.addSubview(dateLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 180),
            
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            profileImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            dateLabel.heightAnchor.constraint(equalToConstant: 50),
            dateLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -20),
            dateLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor)
        ])
    }
    
    func setupTrip(_ trip: TripModel) {
        profileImageView.image = UIImage(data: trip.image)
        titleLabel.text = trip.title
        dateLabel.text = trip.date
    }
}
