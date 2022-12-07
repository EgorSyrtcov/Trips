//
//  MainCell.swift
//  Trips
//
//  Created by Egor Syrtcov on 30.11.22.
//

import UIKit

class MainCell: UITableViewCell {
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let margins = UIEdgeInsets(top: 11, left: 22, bottom: 11, right: 18)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        selectionStyle = .none
    }
    
    private func setupUI() {
        
        // add shadow on cell
        setShadow()
       
        contentView.addSubview(profileImageView)
        profileImageView.addSubview(titleLabel)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
    
    func setupTrip(_ trip: TripModel?) {
        guard let trip = trip else { return }
        titleLabel.text = trip.title
        profileImageView.image = trip.image
    }
}
