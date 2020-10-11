//
//  ViewModel.swift
//  WeathAir-macOS
//
//  Created by Thomas Willson on 10/10/20.
//

import Foundation
import WeathAirShared

class ViewModel : ObservableObject {
    @Published var zipCode: String = ""
    @Published var observation: Observation? = nil
    
    private let api : ObservationAPIService
    
    public init() {
        api = ObservationAPIService(url: "http://127.0.0.1:8000/api/v1/observations-for-zip/")
    }
    
    public func loadData() {
        guard let zipCodeInt = Int(zipCode) else {
            return
        }
        
        api.getObservationsForZipCode(zipCode: zipCodeInt) { (error, observations) in
            guard let observations = observations else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            self.observation = observations.first(where: {o in o.type == "O" && o.primaryPollutant})
        }
    }
}
