//
//  File.swift
//  
//
//  Created by Thomas Willson on 10/10/20.
//

import Foundation
import SwiftyJSON

public enum APIError : Error {
    case locationNotFound
    case networkError
}

public struct ObservationAPIService {
    let url: String
    
    public typealias ObservationCallback = (_ error: Error?, _ observations: [Observation]?) -> ()
	
	public init() {
		self.url = "https://api.weathair.net/api/v1/observations-for-zip/"
	}
    
    public init(url: String) {
        self.url = url
    }
    
    public func getObservationsForZipCode(zipCode: Int,
                                          callback: @escaping ObservationCallback) {
        let requestURL = URL(string: "\(url)?zipcode=\(zipCode)")!
        let task = URLSession.shared.dataTask(with: requestURL) { (data, urlResponse, error) in
            requestComplete(callback: callback, data: data, urlResponse: urlResponse, error: error)
        }
        task.resume()
    }
    
    private func requestComplete(callback: ObservationCallback, data: Data?, urlResponse: URLResponse?, error: Error?) {
        if let error = error {
            callback(error, nil)
        }
        
        guard let data = data else {
            callback(APIError.networkError, nil)
            return
        }
        
        do {
            let json = try JSON(data: data)
            var observations = [Observation]()
            
            for observationJSON in json["results"].arrayValue {
                let observation = Observation(fromJson: observationJSON)
                observations.append(observation)
            }
            
            callback(nil, observations)
        } catch {
            callback(error, nil)
        }
    }
}
