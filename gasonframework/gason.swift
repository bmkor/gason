//
//  gason.swift
//  gasonframework
//
//  Created by Benjamin on 26/11/2017.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import Foundation
/**
 JSON is a gason wrapper 
 */


open class JSON{
    fileprivate var g:gason
    public init(_ data:Data) throws {
        self.g = gason(data: data)
        let status = self.g.parseStatus
        guard status == 0 else{ throw JSONErrorType(rawValue:Int(status)) }
        return
    }
    
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
    
    public var string:String?{
        get{
            return self.g.toString()
        }
    }
    
    public var double:Double?{
        get{
            return self.g.toNumber()?.doubleValue
        }
    }
    
    public var bool:Bool?{
        get{
            return self.g.toBool()?.boolValue
        }
    }
    
    public var int:Int?{
        get{
            return self.g.toNumber()?.intValue
        }
    }
    
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
