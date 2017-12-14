//
//  gason.swift
//  gasonframework
//
//  Created by Benjamin on 26/11/2017.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import Foundation
/**
 JSON is in fact a gason wrapper.
 */


open class JSON{
    fileprivate var g:gason
    
    /**
     Initialize JSON by NSData. Throw will occur if the data cannot be parsed as a valid JSON.
     */
    public init(_ data:Data) throws {        
        self.g = gason(data: data)
        let status = self.g.parseStatus
        guard status == 0 else{ throw JSONErrorType(rawValue:Int(status)) }
        return
    }

    /**
     Initialize JSON by a string (Slower). The string will be converted to NSData for initialization.
     */
    convenience init(json:String) throws {
        guard let data = json.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            throw JSONErrorType.BAD_STRING
        }
        try self.init(data)
        return
    }
    
    fileprivate init(g:gason){
        self.g = g
    }
    
    /**
     Cast the JSON to a string.
     */
    public var string:String?{
        get{
            return self.g.toString()
        }
    }

    /// Cast the JSON to a double.
    public var double:Double?{
        get{
            return self.g.toNumber()?.doubleValue
        }
    }
    
    /// Cast the JSON to a bool.
    public var bool:Bool?{
        get{
            return self.g.toBool()?.boolValue
        }
    }

    /// Cast the JSON to an integer.
    public var int:Int?{
        get{
            return self.g.toNumber()?.intValue
        }
    }
    
    /// Gives the length of the JSON if it is an array or an object.
    public var length:UInt?{
        get{
            return self.g.length()?.uintValue
        }
    }
}

extension JSON:IteratorProtocol{
    public func next() -> JSON? {
        let n = self.g.next()
        return n == nil ? nil : JSON(g:n!)
    }
}

extension JSON:Sequence{
    public func makeIterator() -> JSON {
        return self
    }
}

extension JSON:CustomStringConvertible{
    public var description: String{
        get{
            return self.g.dumpValue(0)
        }
    }
}

extension JSON{
    subscript(i:UInt)->JSON?{
        get{
            guard let gg = self.g[i] else {
                return nil
            }
            return JSON(g:gg)
        }
    }
    
    subscript(key:String)->JSON?{
        get{
            guard let gg = self.g[key] else{
                return nil
            }
            return JSON(g:gg)
        }
    }
    
}
