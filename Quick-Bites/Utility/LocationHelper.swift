//
//  LocationHelper.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 30.12.2022.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject {
    private let locationManager = CLLocationManager()
    weak var delegate: LocationDelegate?
    static var cityName: String?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
    }

    func askForInUsePermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func askForAlwaysPermission() {
        locationManager.requestAlwaysAuthorization()
    }

    func isAuthorized() -> Bool {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            return true
        } else {
            return false
        }
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
        let geocoder = CLGeocoder()
        let preferredLocale = Locale(identifier: "en_US") // specify the preferred language
        if let location = lastLocation {
            geocoder.reverseGeocodeLocation(location, preferredLocale: preferredLocale) { (placemarks, error) in
                if let placemarks = placemarks,
                    let lastPlacemark = placemarks.last,
                    let cityName = lastPlacemark.administrativeArea,
                    error == nil {
                    LocationHelper.cityName = cityName
                    self.delegate?.cityNameFound(cityName: cityName)
                }
            }
        }
    }
}
