//
//  Observation.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 11, 2020

import SwiftyJSON
#if os(macOS)
 import Cocoa
#else
 import UIKit
#endif

public class Observation : NSObject, NSCoding {
    
    public var aqiCategory : String!
    public var aqiValue : Int!
    public var discussion : String!
    public var issuedDate : Date!
    public var parameterName : String!
    public var primaryPollutant : Bool!
    public var recordSequence : Int!
    public var reportingArea : ReportingArea!
    public var source : ObservationSource!
    public var type : String!
    public var validDate : Date!
	
	public var color : CGColor {
		#if os(macOS)
		let defaultColor = CGColor.clear
		#else
		let defaultColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0)
		#endif
		
		if let aqiValue = aqiValue {
			switch aqiValue {
			case ...50:
				return convertColor(rgb: 0x00e400)
			case 51...100:
				return convertColor(rgb: 0xffff00)
			case 101...150:
				return convertColor(rgb: 0xff7e000)
			case 151...200:
				return convertColor(rgb: 0xff0000)
			case 201...300:
				return convertColor(rgb: 0x8f3f97)
			case 301...:
				return convertColor(rgb: 0x7e0023)
			default:
				return defaultColor
			}
		} else {
			return defaultColor
		}

	}
	
	private func convertColor(rgb: Int32) -> CGColor {
		return CGColor(red: CGFloat(rgb >> 16) / 255.0, green: CGFloat((rgb >> 8) & 0xFF) / 255.0, blue: CGFloat(rgb & 0xFF) / 255.0, alpha: 1.0)
	}
	
	public override init() {
		aqiCategory = "Good"
		aqiValue = 35
		discussion = "It should get better tomorrow!"
		issuedDate = Date()
		parameterName = "PM2.5"
		primaryPollutant = true
		recordSequence = 0
		reportingArea = ReportingArea()
		source = ObservationSource()
		type = "O"
		validDate = Date()
		
		super.init()
	}
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        super.init()
        
        if json.isEmpty{
            return
        }
        aqiCategory = json["aqi_category"].stringValue
        aqiValue = json["aqi_value"].intValue
        discussion = json["discussion"].stringValue
        issuedDate = convertDate(json: json["issued_date"])
        parameterName = json["parameter_name"].stringValue
        primaryPollutant = json["primary_pollutant"].boolValue
        recordSequence = json["record_sequence"].intValue
        let reportingAreaJson = json["reporting_area"]
        if !reportingAreaJson.isEmpty{
            reportingArea = ReportingArea(fromJson: reportingAreaJson)
        }
        let sourceJson = json["source"]
        if !sourceJson.isEmpty{
            source = ObservationSource(fromJson: sourceJson)
        }
        type = json["type"].stringValue
        validDate = convertDate(json: json["valid_date"])
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if aqiCategory != nil{
            dictionary["aqi_category"] = aqiCategory
        }
        if aqiValue != nil{
            dictionary["aqi_value"] = aqiValue
        }
        if discussion != nil{
            dictionary["discussion"] = discussion
        }
        if issuedDate != nil{
            dictionary["issued_date"] = issuedDate
        }
        if parameterName != nil{
            dictionary["parameter_name"] = parameterName
        }
        if primaryPollutant != nil{
            dictionary["primary_pollutant"] = primaryPollutant
        }
        if recordSequence != nil{
            dictionary["record_sequence"] = recordSequence
        }
        if reportingArea != nil{
            dictionary["reportingArea"] = reportingArea.toDictionary()
        }
        if source != nil{
            dictionary["source"] = source.toDictionary()
        }
        if type != nil{
            dictionary["type"] = type
        }
        if validDate != nil{
            dictionary["valid_date"] = validDate
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required public init(coder aDecoder: NSCoder)
    {
        aqiCategory = aDecoder.decodeObject(forKey: "aqi_category") as? String
        aqiValue = aDecoder.decodeObject(forKey: "aqi_value") as? Int
        discussion = aDecoder.decodeObject(forKey: "discussion") as? String
        issuedDate = aDecoder.decodeObject(forKey: "issued_date") as? Date
        parameterName = aDecoder.decodeObject(forKey: "parameter_name") as? String
        primaryPollutant = aDecoder.decodeObject(forKey: "primary_pollutant") as? Bool
        recordSequence = aDecoder.decodeObject(forKey: "record_sequence") as? Int
        reportingArea = aDecoder.decodeObject(forKey: "reporting_area") as? ReportingArea
        source = aDecoder.decodeObject(forKey: "source") as? ObservationSource
        type = aDecoder.decodeObject(forKey: "type") as? String
        validDate = aDecoder.decodeObject(forKey: "valid_date") as? Date
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    public func encode(with aCoder: NSCoder)
    {
        if aqiCategory != nil{
            aCoder.encode(aqiCategory, forKey: "aqi_category")
        }
        if aqiValue != nil{
            aCoder.encode(aqiValue, forKey: "aqi_value")
        }
        if discussion != nil{
            aCoder.encode(discussion, forKey: "discussion")
        }
        if issuedDate != nil{
            aCoder.encode(issuedDate, forKey: "issued_date")
        }
        if parameterName != nil{
            aCoder.encode(parameterName, forKey: "parameter_name")
        }
        if primaryPollutant != nil{
            aCoder.encode(primaryPollutant, forKey: "primary_pollutant")
        }
        if recordSequence != nil{
            aCoder.encode(recordSequence, forKey: "record_sequence")
        }
        if reportingArea != nil{
            aCoder.encode(reportingArea, forKey: "reporting_area")
        }
        if source != nil{
            aCoder.encode(source, forKey: "source")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if validDate != nil{
            aCoder.encode(validDate, forKey: "valid_date")
        }
    }
    
    private func convertDate(json: JSON) -> Date? {
        guard let dateString = json.string else {
            return nil
        }
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        let date = dateFormatter.date(from: dateString)
        return date
    }
    
}
