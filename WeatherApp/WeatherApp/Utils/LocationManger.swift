//
//  LocationManger.swift
//  Dubai Taxi
//
//  Created by Alaa on 1/29/20.
//  Copyright © 2020 TACME. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManger:NSObject,CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
    }
    
    var configureLocation:((Double,Double)->())?
    var disallowLocation:((String)->())?
    
    func getCurrenLocation(configureLocation:@escaping (Double,Double)->())  {
        self.configureLocation = configureLocation
        let status = CLLocationManager.authorizationStatus()
        
        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
            locationManager.requestWhenInUseAuthorization()
        }
        if(status == .notDetermined){
            locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.delegate = self
        locationManager.requestLocation()
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            configureLocation?(location.coordinate.latitude,location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
            
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
            
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
            disallowLocation?("user tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            print("parental control setting disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        default: break
        }
    }
}
