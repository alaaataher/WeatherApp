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

    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var pressureValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var weatherDescriptionValue: UILabel!
    @IBOutlet weak var weatherInfoView: UIView!
    private let viewModel = FindingWeatherViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
    }

    private func setupView() {
        searchTextField.delegate = self
        weatherInfoView.isHidden = true
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
        setupWeatherDataBinding()
        setupLoadingBinding()
        setupErrorBinding()
    }

    private func setupWeatherDataBinding() {
        viewModel.weatherItem = { [weak self] item in
            DispatchQueue.main.async {
                self?.weatherInfoView.isHidden = false
                self?.tempValueLabel.text = "\(item.temp)"
                self?.pressureValueLabel.text = "\(item.pressure)"
                self?.humidityValueLabel.text = "\(item.humidity)"
                self?.weatherDescriptionValue.text = item.weatherDescription
            }
        }
    }

    private func setupErrorBinding() {
            viewModel.errorMessage = { message in
                DispatchQueue.main.async {
                SwiftMessageBar.showMessage(withTitle: "Error", message: message , type: .error)
            }
        }
    }

    private func setupLoadingBinding() {
        viewModel.isLoading = { isload in
            DispatchQueue.main.async {
                isload ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            }
        }
    }
}
