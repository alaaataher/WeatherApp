//
//  FindingWeatherViewController.swift
//  WeatherApp
//
//  Created by Alaa Taher on 07/10/2021.
//

import UIKit

class FindingWeatherViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        searchTextField.delegate = self
    }
}

extension FindingWeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
