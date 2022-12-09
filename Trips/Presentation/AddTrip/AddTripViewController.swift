//
//  AddTripViewController.swift
//  Trips
//
//  Created by Egor Syrtcov on 1.12.22.
//

import UIKit
import Photos

final class AddTripViewController: UIViewController {
    
    private let service = LocalService()
    
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
//        button.addTarget(self, action: #selector(autocompleteClicked), for: .touchUpInside)
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
    
    var completionSaveModel: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        setupUI()
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
        completionSaveModel?()
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
        
        guard let imageData = tripImageView.image?.pngData() else { return }
        let newTrip = TripModel(title: place, image: imageData, date: text)
        service.tripModels.append(newTrip)
        
        navigationController?.popViewController(animated: true)
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
                default:
                    break
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
    
    private func setupUI() {
        view.addSubview(placeLabel)
        view.addSubview(addPlaceButton)
        view.addSubview(dateTextField)
        view.addSubview(tripImageView)
        view.addSubview(saveButton)
        
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        addPlaceButton.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        tripImageView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
 
        NSLayoutConstraint.activate([
            placeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            placeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            placeLabel.heightAnchor.constraint(equalToConstant: 50),
            
            addPlaceButton.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: 10),
            addPlaceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addPlaceButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            addPlaceButton.heightAnchor.constraint(equalToConstant: 50),
            
            dateTextField.topAnchor.constraint(equalTo: addPlaceButton.bottomAnchor, constant: 30),
            dateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dateTextField.heightAnchor.constraint(equalToConstant: 50),
            
            tripImageView.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 30),
            tripImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tripImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tripImageView.heightAnchor.constraint(equalToConstant: 250),
            
            saveButton.topAnchor.constraint(equalTo: tripImageView.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
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
