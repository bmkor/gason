//
//  gasonError.swift
//  gasonframework
//
//  Created by Benjamin on 2/12/2017.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import Foundation

public enum JSONErrorType: Error{
    case JSON_OK
    case BAD_NUMBER
    case BAD_STRING
    case BAD_IDENTIFIER
    case STACK_OVERFLOW
    case STACK_UNDERFLOW
    case MISMATCH_BRACKET
    case UNEXPECTED_CHARACTER
    case UNQUOTED_KEY
    case BREAKING_BAD
    case ALLOCATION_FAILURE
    case UNKNOWN
    
    init(rawValue:Int){
        switch rawValue {
        case 0:
            self = .JSON_OK
            break
        case 1:
            self = .BAD_NUMBER
            break
        case 2:
            self = .BAD_STRING
            break
        case 3:
            self = .BAD_IDENTIFIER
            break
        case 4:
            self = .STACK_OVERFLOW
            break
        case 5:
            self = .STACK_UNDERFLOW
            break
        case 6:
            self = .MISMATCH_BRACKET
            break
        case 7:
            self = .UNEXPECTED_CHARACTER
            break
        case 8:
            self = .UNQUOTED_KEY
            break
        case 9:
            self = .BREAKING_BAD
            break
        case 10:
            self = .ALLOCATION_FAILURE
            break
        default:
            self = .UNKNOWN
        }
    }
}

extension JSONErrorType: LocalizedError{
    public var errorDescription: String?{
        switch self{
        case .JSON_OK:
            return "JSON_OK"
        case .ALLOCATION_FAILURE:
            return "ALLOCATION_FAILURE"
        case .BAD_IDENTIFIER:
            return "BAD_IDENTIFIER"
        case .BAD_NUMBER:
            return "BAD_NUMBER"
        case .BAD_STRING:
            return "BAD_STRING"
        case .BREAKING_BAD:
            return "BREAKING_BAD"
        case .MISMATCH_BRACKET:
            return "MISMATCH_BRACKET"
        case .STACK_OVERFLOW:
            return "STACK_OVERFLOW"
        case .STACK_UNDERFLOW:
            return "STACK_UNDERFLOW"
        case .UNEXPECTED_CHARACTER:
            return "UNEXPECTED_CHARACTER"
        case .UNKNOWN:
            return "UNKNOWN"
        case .UNQUOTED_KEY:
            return "UNQUOTED_KEY"
        }
    }
}
 

