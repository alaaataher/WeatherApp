//
//  FindingWeatherViewController.swift
//  WeatherApp
//
//  Created by Alaa Taher on 07/10/2021.
//

import UIKit
import SVProgressHUD
import SwiftMessageBar
import MapKit

class FindingWeatherViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
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
        viewModel.getCurrentLocation()
    }

    private func setupView() {
        searchTextField.delegate = self
        weatherInfoView.isHidden = true
    }

    @IBAction func goButtonAction(_ sender: Any) {
        guard let text = searchTextField.text, !text.isEmpty else {
            return
        }
        viewModel.loadWeatherInfo(with: text)
    }

    @IBAction func currentLocationAction(_ sender: Any) {
        viewModel.getCurrentLocation()
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
                self?.updateWeatherInfoView(item)
                self?.updateMapView(item)
            }
        }
    }

    private func updateWeatherInfoView(_ item: WeatherItem) {
        weatherInfoView.isHidden = false
        tempValueLabel.text = "\(item.temp)"
        pressureValueLabel.text = "\(item.pressure)"
        humidityValueLabel.text = "\(item.humidity)"
        weatherDescriptionValue.text = item.weatherDescription
        searchTextField.text = item.name
    }

    private func updateMapView(_ item: WeatherItem) {
        self.mapView.annotations.forEach {
          if !($0 is MKUserLocation) {
            self.mapView.removeAnnotation($0)
          }
        }
        let annotation = MKPointAnnotation()
        annotation.title = item.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(item.lat) , longitude: CLLocationDegrees(item.lon))
        self.mapView.addAnnotation(annotation)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
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
