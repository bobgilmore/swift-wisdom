//
//  NSData+SubdataTests.swift
//  bmap
//
//  Created by Logan Wright on 12/14/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

import XCTest
@testable import SwiftWisdom

class NSDataSubdataTests: XCTestCase {
    
    let one = "00 11 22"
        .ip_nsdataFromHexadecimalString()!
    let two = "33 44 55 66 77"
        .ip_nsdataFromHexadecimalString()!
    let three = "xx"
        .ip_nsdataFromHexadecimalString()!
    let four = "88 99 aa bb cc dd ee ff"
        .ip_nsdataFromHexadecimalString()!
    
    lazy var subdataArray: [NSData] = [self.one, self.two, self.three, self.four]
    lazy var data: NSData = self.subdataArray.combine()

    func testSubdata() {
        let fullSubData = data.ip_subdataFrom(0, length: data.length)
        XCTAssert(data == fullSubData)
        
        let emptySubDataValidIdx = data.ip_subdataFrom(5, length: 0)
        XCTAssert(emptySubDataValidIdx == nil)
        
        let emptySubDataInvalidIdx = data.ip_subdataFrom(1000, length: 234)
        XCTAssert(emptySubDataInvalidIdx == nil)
        
        let outOfRange = data.ip_subdataFrom(0, length: data.length + 1)
        XCTAssert(outOfRange == nil)
        
        subdataArray.enumerated().forEach { idx, compareSubdata in
            let previousData = subdataArray
                .prefix(upTo: idx)
                .combine()
            
            
            let subdata = data.ip_subdataFrom(previousData.length, length: compareSubdata.length)
            XCTAssert(subdata == compareSubdata)
        }
    }

    func testSubscriptIdx() {
        let zero = "4f"
        let one = "87"
        let two = "4f"
        let three = "a0"
        let combination = [zero, one, two, three].joined(separator: "")
        let data = combination.ip_nsdataFromHexadecimalString()!
        
        let zeroData = data[0]!
        XCTAssert(zeroData == zero.ip_nsdataFromHexadecimalString()!)
        
        let oneData = data[1]!
        XCTAssert(oneData == one.ip_nsdataFromHexadecimalString()!)
        
        let twoData = data[2]!
        XCTAssert(twoData == two.ip_nsdataFromHexadecimalString()!)
        
        let threeData = data[3]!
        XCTAssert(threeData == three.ip_nsdataFromHexadecimalString()!)
        
        let empty = data[100]
        XCTAssert(empty == nil)
    }
    
    func testPrefixSuffix() {
        let prefix = "af43 efda 651a".ip_nsdataFromHexadecimalString() as! Data
        let suffix = "f4b4 2343".ip_nsdataFromHexadecimalString() as! Data
        
        let data = NSMutableData()
        data.append(prefix)
        data.append(suffix)
        
        let gotPrefix = data.ip_prefixThrough(prefix.count - 1) as? Data
        XCTAssert(gotPrefix == prefix)
        
        let gotSuffix = data.ip_suffixFrom(prefix.count) as? Data
        XCTAssert(gotSuffix == suffix)
        
        let emptyPrefix = data.ip_prefixThrough(-1)
        XCTAssert(emptyPrefix == nil)
        
        let emptySuffix = data.ip_suffixFrom(100)
        XCTAssert(emptySuffix == emptySuffix)
    }

    func testSubscriptRange() {
        let zero = "4f"
        let one = "87"
        let two = "4f"
        let three = "a0"
        let combination = [zero, one, two, three].joined(separator: "")
        let data = combination.ip_nsdataFromHexadecimalString()!
        
        let getZeroAndOne = data[0...1]
        let zeroAndOne = (zero + one).ip_nsdataFromHexadecimalString()!
        XCTAssert(getZeroAndOne == zeroAndOne)
        
        let getOneTwoThree = data[1...3]
        let oneTwoThree = (one + two + three).ip_nsdataFromHexadecimalString()!
        XCTAssert(oneTwoThree == getOneTwoThree)
        
        let outOfRange = data[2...250]
        XCTAssert(outOfRange == nil)
        
        let outOfRangeLow = data[-2...4]
        XCTAssert(outOfRangeLow == nil)
    }
}

extension ArraySlice where Element: NSData {
    func combine() -> NSData {
        let data = NSMutableData()
        self.forEach { data.append($0 as Data) }
        return data as NSData
    }
}

extension Array where Element: NSData {
    func combine() -> NSData {
        let data = NSMutableData()
        self.forEach { data.append($0 as Data) }
        return data as NSData
    }
}