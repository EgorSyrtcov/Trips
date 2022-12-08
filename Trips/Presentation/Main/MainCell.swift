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
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "12/12/12"
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
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
        profileImageView.addSubview(dateLabel)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
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
    
    func setupTrip(_ trip: TripModel?) {
        guard let trip = trip else { return }
        titleLabel.text = trip.title
        profileImageView.image = UIImage(data: trip.image)
        dateLabel.text = trip.date
    }
}
