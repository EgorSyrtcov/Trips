//
//  AddTripViewController.swift
//  Trips
//
//  Created by Egor Syrtcov on 1.12.22.
//

import UIKit
import GooglePlaces
import Photos

final class AddTripViewController: UIViewController {
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "No select place"
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }()
    
    lazy var addPlaceButton: UIButton = {
       let button = UIButton()
        button.setTitle("Add the place", for: .normal)
        button.tintColor = .orange
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(autocompleteClicked), for: .touchUpInside)
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker(frame: .zero)
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .inline
        dp.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        dp.maximumDate = Calendar.current.date(byAdding: .month, value: 0, to: Date())
        return dp
    }()
    
    lazy var dateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter date of arrival"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    lazy var tripImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "defaultImageTrip")
        iv.contentMode = .scaleToFill
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageSelector)))
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        setupPicker()
        doneButtonInPicker()
    }
    
    private func setupPicker() {
        dateTextField.inputView = datePicker
    }
    
    private func doneButtonInPicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.setItems([flexSpace, doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneAction() {
        getDateFromPicker()
        view.endEditing(true)
    }
    
    @objc func handleSaveButton() {
        checkField()
    }
    
    private func checkField() {
        
        guard let place = placeLabel.text, place != "No select place" else {
            let alert = UIAlertController(
                title: "Alert",
                message: "You need to add place",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(
                title: "OK",
                style: .default
            )
            alert.addAction(okAction)
            self.present(alert, animated: true)
            return
        }
        
        guard let text = dateTextField.text, !text.isEmpty else {
            let alert = UIAlertController(
                title: "Alert",
                message: "You need to add an arrival date ",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(
                title: "OK",
                style: .default
            )
            alert.addAction(okAction)
            self.present(alert, animated: true)
            return
        }
        
        print("Save")
    }
    
    @objc private func handleImageSelector() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                switch status {
                case .notDetermined:
                    if status == .authorized {
                        self?.presentPhotoPickerController()
                    }
                case .restricted:
                    let alert = UIAlertController(
                        title: "Photo Library Restricted",
                        message: "Photo Library access is restricted and cannot be accessed",
                        preferredStyle: .alert
                    )
                    let okAction = UIAlertAction(
                        title: "OK",
                        style: .default
                    )
                    alert.addAction(okAction)
                    self?.present(alert, animated: true)
                case .denied:
                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "Photo Library Denied",
                            message: "Photo Library access was previously denied. Please update your settings if you wish to change this.",
                            preferredStyle: .alert
                        )
                        let settingAction = UIAlertAction(
                            title: "Go to Settings",
                            style: .default) {
                            action in
                            let url = URL(string: UIApplication.notificationSettingsURLString!)
                            UIApplication.shared.open(url!)
                        }
                        alert.addAction(settingAction)

                        let cancelAction = UIAlertAction(
                            title: "Cancel",
                            style: .cancel
                        )
                        alert.addAction(cancelAction)

                        self?.present(alert, animated: true)
                    }
                case .authorized:
                    self?.presentPhotoPickerController()
                case .limited:
                    if status == .authorized {
                        self?.presentPhotoPickerController()
                    }
                }
            }
        }
    }
    
    private func presentPhotoPickerController() {
        DispatchQueue.main.async {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .savedPhotosAlbum
            self.present(myPickerController, animated: true)
        }
    }
    
    private func setupConstraints() {
        view.addSubview(placeLabel)
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        
    //constant: -60
        NSLayoutConstraint.activate([
            placeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            placeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            placeLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(addPlaceButton)
        addPlaceButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addPlaceButton.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: 10),
            addPlaceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addPlaceButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            addPlaceButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(dateTextField)
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateTextField.topAnchor.constraint(equalTo: addPlaceButton.bottomAnchor, constant: 30),
            dateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dateTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(tripImageView)
        tripImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tripImageView.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 30),
            tripImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tripImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tripImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: tripImageView.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @objc func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true)
    }
    
}

extension AddTripViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        placeLabel.text = place.name
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension AddTripViewController {
    
    func getDateFromPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        dateTextField.text = formatter.string(from: datePicker.date)
    }
}

extension AddTripViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            self.tripImageView.image = image
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        AddTripViewController().showPreview().ignoresSafeArea()
    }
}
#endif
