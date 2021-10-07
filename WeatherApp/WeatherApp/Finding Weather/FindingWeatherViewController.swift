//
//  FindingWeatherViewController.swift
//  WeatherApp
//
//  Created by Alaa Taher on 07/10/2021.
//

import UIKit
import SVProgressHUD
import SwiftMessageBar

class FindingWeatherViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    private let viewModel = FindingWeatherViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
    }

    private func setupView() {
        searchTextField.delegate = self
    }

    @IBAction func goButtonAction(_ sender: Any) {
        guard let text = searchTextField.text else {
            return
        }
        viewModel.loadWeatherInfo(with: text)
    }
}

extension FindingWeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//Binding
extension FindingWeatherViewController {
    private func setupBinding() {
        setupLoadingBinding()
        setupErrorBinding()
    }

    private func setupErrorBinding() {
        viewModel.errorMessage = { message in
            SwiftMessageBar.showMessage(withTitle: "Error", message: message , type: .error)
        }
    }

    private func setupLoadingBinding() {
        viewModel.isLoading = { isload in
            isload ? SVProgressHUD.show() : SVProgressHUD.dismiss()
        }
    }
}
