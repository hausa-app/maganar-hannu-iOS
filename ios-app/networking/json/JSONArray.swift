//
//  JSONArray.swift
//  wuerfel
//
//  Created by Emre Can Bolat on 13.11.17.
//  Copyright © 2017 Emre Can Bolat. All rights reserved.
//

import Foundation

class JSONArray: CustomStringConvertible {
    
    final var values: Array<Any>
    
    var description : String {
        return "[" + values.description.replacingOccurrences(of: "[", with: "{").replacingOccurrences(of: "]", with: "}").dropFirst().dropLast() + "]"
    }
    
    init() {
        values = Array<Any>()
    }
    
    convenience init(readFrom: JSONTokener) {
        self.init()
        let object = readFrom.nextValue()
        if object is JSONArray {
            let object = object as! JSONArray
            self.values = object.values
        } else {
            print("JSONArray TypeMismatch")
        }
    }
    
    convenience init(json: String) {
        self.init(readFrom: JSONTokener(ins: json))
    }
    
    convenience init(array: Any) {
        self.init()
        if !(array is Array<Any>) {
            print("Not a primitive array!")
            return
        }
        let length = (array as! Array<Any>).count
        for index in stride(from: 0, to: length, by: 1) {
            put(value: (array as! Array<Any>)[index])
        }
    }
    
    func put(value: Any?) {
        values.append(value!)
    }
    
}
