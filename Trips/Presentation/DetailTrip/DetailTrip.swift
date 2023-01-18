//
//  DetailTrip.swift
//  Trips
//
//  Created by Egor Syrtcov on 9.12.22.
//

import UIKit

final class DetailTrip: UIViewController {
    
    private let service = Service()
    private let locationService = LocalService()
    private let containerView = UIView()
    private var placeId: String?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Bali Trip!"
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 42)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "12/12/12"
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailView: UIView = {
        let detailView = UIView()
        detailView.translatesAutoresizingMaskIntoConstraints = false
        return detailView
    }()

    private let сountryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Country: "
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let shortCountryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Short: "
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLatLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Lat: "
        label.font = UIFont(name: "GillSans-SemiBoldItalic", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLngLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Lng: "
        label.font = UIFont(name: "GillSans-SemiBoldItalic", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textBox: UITextView = {
       let textBox = UITextView()
        textBox.autocorrectionType = .no
        textBox.text = "Note"
        textBox.font = UIFont.preferredFont(forTextStyle: .body)
        textBox.layer.cornerRadius = 20
        textBox.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textBox.translatesAutoresizingMaskIntoConstraints = false
        return textBox
    }()

    private lazy var saveButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .red
        button.tintColor = .white
        button.setTitle("SAVE", for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(DetailTrip.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailTrip.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setup() {
        self.navigationItem.title = "Detail trip"
        view.backgroundColor = .lightGray
        
        // add shadow and cornerRadius
        containerView.layer.cornerRadius = 10
        containerView.setShadow()
        
        Task {
            await requestDetailCity(id: placeId ?? "")
        }
    }
    
    private func requestDetailCity(id: String) async {
        
        let city = try? await service.execute(.detailRequest(id: id), expecting: DetailCity.self)

        await MainActor.run { [weak self] in
            self?.сountryLabel.text = "Country: \(city?.country ?? "")"
            self?.shortCountryLabel.text = "Short: \(city?.shortName ?? "")"
            self?.locationLatLabel.text = "Lat: \(city?.result.geometry.location.lat ?? 0)"
            self?.locationLngLabel.text = "Lng: \(city?.result.geometry.location.lng ?? 0)"
        }
    }
    
    private func setupUI() {
        view.addSubviews(containerView, detailView)
        containerView.addSubview(profileImageView)
        profileImageView.addSubviews(titleLabel, dateLabel)
        detailView.addSubviews(сountryLabel, shortCountryLabel,saveButton, locationLatLabel, locationLngLabel, textBox)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
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
            dateLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            
            detailView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            detailView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            сountryLabel.topAnchor.constraint(equalTo: detailView.topAnchor),
            сountryLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 10),
            сountryLabel.rightAnchor.constraint(equalTo: detailView.rightAnchor),
            сountryLabel.heightAnchor.constraint(equalToConstant: 50),
            
            shortCountryLabel.topAnchor.constraint(equalTo: сountryLabel.bottomAnchor),
            shortCountryLabel.leadingAnchor.constraint(equalTo: сountryLabel.leadingAnchor),
            shortCountryLabel.rightAnchor.constraint(equalTo: сountryLabel.rightAnchor),
            shortCountryLabel.heightAnchor.constraint(equalToConstant: 50),
            
            locationLatLabel.topAnchor.constraint(equalTo: shortCountryLabel.bottomAnchor),
            locationLatLabel.leadingAnchor.constraint(equalTo: shortCountryLabel.leadingAnchor),
            locationLatLabel.rightAnchor.constraint(equalTo: locationLngLabel.leftAnchor, constant: -10),
            locationLatLabel.heightAnchor.constraint(equalToConstant: 50),
            
            locationLngLabel.topAnchor.constraint(equalTo: shortCountryLabel.bottomAnchor),
            locationLngLabel.rightAnchor.constraint(equalTo: detailView.rightAnchor),
            locationLngLabel.heightAnchor.constraint(equalToConstant: 50),
            
            textBox.topAnchor.constraint(equalTo: locationLatLabel.bottomAnchor, constant: 20),
            textBox.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 20),
            textBox.rightAnchor.constraint(equalTo: detailView.rightAnchor, constant: -20),
            textBox.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
            
            saveButton.centerXAnchor.constraint(equalTo: detailView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: detailView.bottomAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 120),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func handleSaveButton() {
        guard let placeId = placeId else { return }
        locationService.addDetails(placeId: placeId, note: textBox.text)
        navigationController?.popViewController(animated: true)
    }
    
    func setupTrip(_ trip: TripModel) {
        textBox.text = trip.note
        placeId = trip.placeId
        profileImageView.image = UIImage(data: trip.image)
        titleLabel.text = trip.title
        dateLabel.text = trip.date
    }
}

// MARK: KEYBOARD Action
extension DetailTrip {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.view.bounds.origin.y == 0 {
            self.view.bounds.origin.y += keyboardFrame.height
            сountryLabel.isHidden = true
            shortCountryLabel.isHidden = true
            locationLngLabel.isHidden = true
            locationLatLabel.isHidden = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.bounds.origin.y != 0 {
            self.view.bounds.origin.y = 0
            сountryLabel.isHidden = false
            shortCountryLabel.isHidden = false
            locationLngLabel.isHidden = false
            locationLatLabel.isHidden = false
        }
    }
}
