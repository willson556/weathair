//
//  ReportingArea.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 11, 2020

import SwiftyJSON
import Foundation
import CoreLocation


public class ReportingArea : NSObject, NSCoding{

    public var location : CLLocationCoordinate2D!
    public var name : String!
    public var stateCode : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
        super.init()
        
        if json.isEmpty{
			return
		}
        
        let locationJson = json["location"]
        if !locationJson.isEmpty{
            location = convertLocation(json: locationJson)
        }
        name = json["name"].stringValue
        stateCode = json["state_code"].stringValue
	}
    
    private func convertLocation(json: JSON) -> CLLocationCoordinate2D? {
        let coordinates = json["coordinates"]
        guard let latitude = coordinates[0].double, let longitude = coordinates[1].double else {
            return nil
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if location != nil{
        	dictionary["location"] = [
                "latitude": location.latitude,
                "longitude": location.longitude,
            ]
        }
        if name != nil{
        	dictionary["name"] = name
        }
        if stateCode != nil{
        	dictionary["state_code"] = stateCode
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required public init(coder aDecoder: NSCoder)
	{
		location = aDecoder.decodeObject(forKey: "location") as? CLLocationCoordinate2D
		name = aDecoder.decodeObject(forKey: "name") as? String
		stateCode = aDecoder.decodeObject(forKey: "state_code") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    public func encode(with aCoder: NSCoder)
	{
		if location != nil{
			aCoder.encode(location, forKey: "location")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if stateCode != nil{
			aCoder.encode(stateCode, forKey: "state_code")
		}
	}
}
