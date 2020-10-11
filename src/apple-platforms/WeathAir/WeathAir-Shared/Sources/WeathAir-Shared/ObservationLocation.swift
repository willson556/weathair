//
//  Location.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 11, 2020

import SwiftyJSON
import Foundation

class ObservationLocation : NSObject, NSCoding{

    var coordinates : [Float]!
    var type : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        coordinates = [Float]()
        let coordinatesArray = json["coordinates"].arrayValue
        for coordinatesJson in coordinatesArray{
            coordinates.append(coordinatesJson.floatValue)
        }
        type = json["type"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if coordinates != nil{
        	dictionary["coordinates"] = coordinates
        }
        if type != nil{
        	dictionary["type"] = type
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		coordinates = aDecoder.decodeObject(forKey: "coordinates") as? [Float]
		type = aDecoder.decodeObject(forKey: "type") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if coordinates != nil{
			aCoder.encode(coordinates, forKey: "coordinates")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}

	}

}
