//
//  WebViewController.swift
//  Bosque
//
//  Created by Leonardo Saganski on 31/08/17.
//  Copyright © 2017 BigBrain. All rights reserved.
//

import CoreLocation

public protocol LocationControllerDelegate {
    func refreshUIFromLocation(msg: Int)
}

class LocationController: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?

    public var delegate: LocationControllerDelegate?

    //Singleton ----
    static let shared = LocationController()
    // -------------

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let user = Globals.shared.loggedUser {
            if locations.count > 0 {
                if let last = locations.last {
                    let accuracy = last.horizontalAccuracy
                    if accuracy <= Constants.LocationParams.DESIRED_ACCURACY {
                        let lati = Constants.DestinationLocation.DESTINATION_LATITUDE
                        let long = Constants.DestinationLocation.DESTINATION_LONGITUDE
                        let distanceInMeters = Int(last.distance(from: CLLocation(latitude: lati, longitude: long)))

                        if Globals.shared.metersToDestination == 0 {
                            Globals.shared.metersToDestination = distanceInMeters
                        }

                        Globals.shared.metersLeftToDestination = distanceInMeters
                        Globals.shared.metersReachedToDestination = Globals.shared.metersToDestination! - distanceInMeters
                        Globals.shared.percentReachedToDestination = (100 / Globals.shared.metersToDestination!) * Globals.shared.metersReachedToDestination!

                        self.delegate?.refreshUIFromLocation(msg: 101)

                    }
                }
            }
        }
    }

    func stopAllLocations() {
        locationManager?.stopUpdatingLocation()
    }

    func startStandardLocationService() {
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()

        Globals.shared.metersToDestination = 0
        Globals.shared.metersReachedToDestination = 0
    }

    func startManagers() {
        locationManager = CLLocationManager()
        if CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager?.requestAlwaysAuthorization()
        }
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.activityType = .automotiveNavigation
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //    locationManager?.distanceFilter = 25.0
    }

    public func start() {
        stopAllLocations()
        startManagers()
        startStandardLocationService()
    }
}
