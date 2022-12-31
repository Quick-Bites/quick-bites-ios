//
//  LocationHelper.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 30.12.2022.
//

import Foundation
import CoreLocation

class LocationHelper:NSObject {
    private let locationManager = CLLocationManager()
    weak var delegate: LocationDelegate?
    private var city: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 5000
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
    }
    
    func askForInUsePermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func askForAlwaysPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func getCityName() -> String? {
        return city
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
        let geocoder = CLGeocoder()
        let preferredLocale = Locale(identifier: "en_US")  // specify the preferred language
        if let location = lastLocation {
            geocoder.reverseGeocodeLocation(location, preferredLocale: preferredLocale) { (placemarks, error) in
                if  let placemarks = placemarks,
                    let lastPlacemark = placemarks.last,
                    let cityName = lastPlacemark.administrativeArea,
                    error == nil {
                        print("City: \(cityName)")
                    self.city = cityName
                    self.delegate?.cityNameFound(cityName: cityName)
                }
            }
        }
    }
}

