//
//  JSONObject.swift
//  wuerfel
//
//  Created by Emre Can Bolat on 10.11.17.
//  Copyright © 2017 Emre Can Bolat. All rights reserved.
//

import Foundation

class JSONObject: CustomStringConvertible {
    
    final var nameValuePairs: Dictionary<String, Any> = Dictionary<String, Any>()
    final var nameValuePairsString: String?
    
    init() {}
    
    var description : String {
        return "{" + nameValuePairs.description.dropFirst().dropLast() + "}"
    }
    
    convenience init(json: String) {
        self.init(readFrom: JSONTokener(ins: json))
    }
    
    convenience init(readFrom: JSONTokener) {
        self.init()
        let object = readFrom.nextValue()
        if object is JSONObject {
            let jsonObject = object as! JSONObject
            self.nameValuePairs = jsonObject.nameValuePairs
        } else {
            print("JSON TypeMismatch")
        }
    }
    
    func get() -> Data {
        return getStringObj().data(using: String.Encoding.utf8)!
    }
    
    func put(name: String, parameter: Any) {
        nameValuePairs[name] = parameter
        
    }
    
    func get(name: String) -> Any? {
        let result = nameValuePairs[name]
        if result == nil {
            return "nil"
        }
        return result
    }
    
    func getStringObj() -> String {
        return "{" + nameValuePairs.description.dropFirst().dropLast() + "}"
    }
    
    func getInt(name: String) -> Int?  {
        let object = get(name: name)
        let result = Int(object as! String)
        if result == nil {
            return nil
        }
        return result
    }
    
    func getBool(name: String) -> Bool?  {
        let object = get(name: name)
        let result = (object as! String).toBool()
        if result == nil {
            return nil
        }
        return result
    }
    
    func getString(name: String) -> String? {
        let object = get(name:name)
        let result = object as! String?
        if result == nil {
            return nil
        }
        return result
    }
    
    func getArray(name: String) -> JSONArray? {
        let object = get(name:name)
        let result = object as! JSONArray?
        if result == nil {
            return nil
        }
        return result
    }

}

