//
//  AddTripViewController.swift
//  Trips
//
//  Created by Egor Syrtcov on 1.12.22.
//

import UIKit
import GooglePlaces

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
            dateTextField.topAnchor.constraint(equalTo: addPlaceButton.bottomAnchor, constant: 10),
            dateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dateTextField.heightAnchor.constraint(equalToConstant: 50)
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
