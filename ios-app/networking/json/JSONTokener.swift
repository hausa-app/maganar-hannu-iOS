//
//  JSONTokener.swift
//  wuerfel
//
//  Created by Emre Can Bolat on 12.11.17.
//  Copyright © 2017 Emre Can Bolat. All rights reserved.
//

import Foundation

class JSONTokener {
    
    final var ins: String
    
    private var pos: Int
    
    init(ins: String?) {
        var ins_ = ins
        if ins_ != nil && (ins_?.starts(with: "\u{feff}"))! {
            ins_ = ins_?.fastSubstring(beginIndex: 1, subLen: nil)
        }
        self.ins = ins_!
        self.pos = 0
    }
    
    func nextValue() -> Any? {
        let c = nextCleanInternal()
        switch c {
        case -1 as Int:
            print (self, "End of input")
        case "{" as String:
            return readObject()
        case "[" as String:
            return readArray()
        case "\\" as String, "\"" as String:
            return nextString(quote: c as! String)
        default:
            pos -= 1
            return readLiteral()
        }
        return c
    }
    
    func readArray() -> JSONArray? {
        let result = JSONArray()
        
        var hasTrailingSeperator = false
        
        while true {
            switch nextCleanInternal() {
            case -1 as Int:
                return nil
            case "]" as String:
                if (hasTrailingSeperator) {
                    result.put(value: nil)
                }
                return result
            case ","as String, ";" as String:
                result.put(value: nil)
                hasTrailingSeperator = true
                continue
            default:
                pos -= 1
            }
            
            
            result.put(value: nextValue())
            
            switch nextCleanInternal() {
            case "]" as String:
                return result
            case "," as String, ";" as String:
                hasTrailingSeperator = true
                continue
            default:
                print("Unterminated array")
            }
        }
    }
    
    func nextCleanInternal() -> Any? {
        while pos < ins.count {
            let c = ins.charAt(index: pos)
            pos += 1
            switch  c {
            case "\t", " ", "\n", "\r":
                continue
                
            case "/":
                if pos == ins.count {
                    return c
                }
                
                let peek = ins.charAt(index: pos)
                switch peek {
                    case "*":
                    pos += 1
                    let commentEnd = ins.indexOf(target: "*/", fromIndex_: pos)
                    if commentEnd == -1 {
                        print ("Unterminated comment")
                        return nil
                    }
                    pos = commentEnd + 2
                    continue
                    
                case "/":
                    pos += 1
                    skipToEndOfLine()
                    continue
                    
                default:
                    return c
                }
                
            case "#":
                skipToEndOfLine()
                continue
                
            default:
                return c
            }
        }
        return -1
    }
    
    func skipToEndOfLine() {
        while (pos < ins.count) {
            let c = ins.charAt(index: pos)
            pos += 1
            if c == "\r" || c == "\n" {
                pos += 1
                break
            }
        }
    }
    
    func readObject() -> JSONObject? {
        let result = JSONObject()
        
        switch nextCleanInternal() {
        case "}"as String:
            return result
        case -1 as Int:
            break
        default:
            pos -= 1
        }
        
        while (true) {
            let name = nextValue()

            if !(name is String ) {
                if name == nil {
                    print("Names cannot be null!")
                    return nil
                } else {
                    print("Names must be strings, but \(String(describing: name)) is not!")
                    return nil
                }
            }
            
            let seperator = nextCleanInternal() as! String
            if (seperator != ":" && seperator != "=") {
                print("Expected ':' after \(String(describing: name))")
                return nil
            }
            
            if (pos < ins.count && ins.charAt(index: pos) == ">") {
                pos += 1
            }
            result.put(name: name as! String, parameter: nextValue()!)
            
            switch nextCleanInternal() {
            case "}" as String:
                return result
            case ";" as String, "," as String:
                continue
            default:
                print("Unterminated object")
            }
        }
    }
    
    func nextString(quote: String) -> String? {
        var builder: StringBuilder?
        var start = pos
        
        while (pos < ins.count) {
            
            let c = ins.charAt(index: pos)
            pos += 1
            if c == quote {
                if builder == nil {
                    return String(ins.fastSubstring(beginIndex: start, subLen: pos - 1))
                } else {
                    builder?.append(s: ins, start: start, end: pos - 1)
                    return builder?.value
                }
            }
            
            if c == "\\" {
                if pos == ins.count {
                    return nil
                }
                if builder == nil {
                    builder = StringBuilder()
                }
                builder?.append(s: ins, start: start, end: pos - 1)
                builder?.append(str: readEscapeCharacter()!)
                start = pos
            }
        }
        return nil
    }
    
    func readEscapeCharacter() -> String? {
        
        let escaped = ins.charAt(index: pos)
        pos += 1
        switch escaped {
        case "u":
            if (pos + 4 > ins.count) {
                return nil
            }
            
            let hex = ins.fastSubstring(beginIndex: pos, subLen: pos + 4)
            pos += 4
            return hex
            
        case "t":
            return "\\t"
        case "b":
            return "\\b"
        case "n":
            return "\\n"
        case "r":
            return "\\r"
        case "f":
            return "\\f"
        case "\\", "\"":
            return escaped
        default:
            return escaped
        }
    }
    
    func readLiteral() -> Any? {
        let literal = nextToInternal(excluded: "{}[]/\\:,=;# \\t\\f")
        if literal.count == 0 {
            return nil
        } else if ("nil".elementsEqual(literal)) {
            return nil
        } else if ("true".elementsEqual(literal)) {
            return true
        } else if ("false".elementsEqual(literal)) {
            return false
        }
        
        if (literal.firstIndex(of: ".")?.encodedOffset == -1) {
            var number = literal
            if (number.starts(with: "0x") || number.starts(with: "0X")) {
                number = number.fastSubstring(beginIndex: 2, subLen: nil)
            } else if (number.starts(with: "0") && number.count > 1) {
                number = number.fastSubstring(beginIndex: 1, subLen: nil)
            }
            
            let longValue = Int64(number)
            if (longValue! <= Int.max && longValue! >= Int.min) {
                return Int(truncatingIfNeeded: longValue!)
            } else {
                return longValue
            }
        }
        
        return String(literal)

    }
    
    func nextToInternal(excluded: String) -> String {
        let start = pos
        for _ in stride(from: pos, to: ins.count, by: 1) {
            let c = ins.charAt(index: pos)
            for index in stride(from: 0, to: excluded.count, by: 1) {
                if excluded.charAt(index: index) == c || c == "\r" || c == "\n"{
                    return ins.fastSubstring(beginIndex: start, subLen: pos)
                }
                
            }
            pos += 1
        }
        return ins.fastSubstring(beginIndex: start, subLen: nil)
    }
}
