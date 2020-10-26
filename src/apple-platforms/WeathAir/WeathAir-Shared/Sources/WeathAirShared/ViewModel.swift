//
//  ViewModel.swift
//  WeathAir-macOS
//
//  Created by Thomas Willson on 10/10/20.
//

import Combine
import Foundation
import CoreLocation
import MapKit

public class ViewModel : ObservableObject {
	@Published public var zipCode: String = "" {
		didSet {
			loadData()
			
			if zipCode != settingsStore.getDefaultZipCode() {
				settingsStore.setDefaultZipCode(zipCode)
			}
		}
	}
	
    @Published public var observation: Observation? = nil
	@Published public var observationsRefreshed: Date? = nil
	
	private let settingsStore: SettingsStore
    private let api : ObservationAPIService
    private var refreshTask : Cancellable? = nil
    private var locationManager : LocationDelegate!
    private let geocoder = CLGeocoder()
    
	public init(settingsStore: SettingsStore) {
		self.settingsStore = settingsStore
        api = ObservationAPIService()
        
        let start = DispatchQueue.SchedulerTimeType(DispatchTime
                                                        .now()
														.advanced(by: DispatchTimeInterval.seconds(20)))
		let interval = DispatchQueue.SchedulerTimeType.Stride(DispatchTimeInterval.seconds(60 * 5))
        let tolerance = DispatchQueue.SchedulerTimeType.Stride(60)
        
        locationManager = LocationDelegate(callback: gotLocation)
		
		if let defaultZipCode = settingsStore.getDefaultZipCode() {
			zipCode = defaultZipCode
		}
        
        refreshTask = DispatchQueue.main.schedule(after: start, interval:interval, tolerance: tolerance, options: nil) {
            self.loadData()
        }
    }
    
    public func useCurrentLocation() {
        locationManager.requestLocation()
    }
    
    private func gotLocation(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            guard let placemark = placemark else{
                print(error!)
                return
            }
            
            guard let postalCode = placemark[0].postalCode else {
                return
            }
            
            DispatchQueue.main.async {
                self.zipCode = postalCode
                self.loadData()
            }
        }
    }
    
    public func loadData() {
        guard zipCode.count == 5,
              let zipCodeInt = Int(zipCode) else {
            return
        }
        
        api.getObservationsForZipCode(zipCode: zipCodeInt) { (error, observations) in
            guard let observations = observations else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.observation = observations.first(where: {o in o.type == "O" && o.primaryPollutant})
				self.observationsRefreshed = Date()
            }
        }
    }
    
    private class LocationDelegate : NSObject, CLLocationManagerDelegate {
		private let updateInterval = TimeInterval(60*15) // 15 minutes
        private let locationManager = CLLocationManager()
        private let callback: (_: CLLocation) -> Void
		private var lastLocation: (location: CLLocation, time: Date)?
        
        init(callback: @escaping (_: CLLocation) -> Void) {
            self.callback = callback
            super.init()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        }
        
        func requestLocation() {
			// Callback immediately with cached location if it's not too out of date
			if lastLocation != nil && lastLocation!.time + updateInterval > Date() {
				callback(lastLocation!.location)
			}
			
            #if os(iOS)
            CLLocationManager().requestWhenInUseAuthorization()
            let status = CLLocationManager.authorizationStatus()
            
            if (status != .authorized && status != .authorizedAlways)
                || !CLLocationManager.locationServicesEnabled() {
                return;
            }
            #elseif os(OSX)
            #else
            #error("Unhandled platform")
            #endif
            
            locationManager.requestLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
			lastLocation = (locations[0], Date())
            callback(locations[0])
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
    }
}
