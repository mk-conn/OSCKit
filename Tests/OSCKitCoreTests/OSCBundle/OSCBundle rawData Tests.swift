//
//  OSCBundle rawData Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import OSCKitCore
import Testing

@Suite struct OSCBundle_rawData_Tests {
    // swiftformat:options --wrapcollections preserve
    
    @Test
    func empty() async throws {
        // tests an empty OSC bundle
        
        // manually build a raw OSC bundle
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // #bundle header
        knownGoodOSCRawBytes += [0x23, 0x62, 0x75, 0x6E, // "#bun"
                                 0x64, 0x6C, 0x65, 0x00] // "dle" null
        // timetag
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x00,
                                 0x00, 0x00, 0x00, 0x01] // 1, int64 big-endian
        
        // decode
        
        let bundle = try OSCBundle(from: knownGoodOSCRawBytes.data)
        
        #expect(bundle.timeTag.rawValue == 1)
        #expect(bundle.elements.isEmpty)
        
        // re-encode
        
        #expect(try bundle.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func singleOSCMessage() async throws {
        // tests an OSC bundle, with one message containing an int32 value
        
        // manually build a raw OSC bundle
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // #bundle header
        knownGoodOSCRawBytes += [0x23, 0x62, 0x75, 0x6E, // "#bun"
                                 0x64, 0x6C, 0x65, 0x00] // "dle" null
        // timetag
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x00,
                                 0x00, 0x00, 0x00, 0x01] // 1, int64 big-endian
        // size of first bundle element
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x18] // 24, int32 big-endian
        
        // first bundle element: OSC Message
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x69, 0x00, 0x00] // ",i" null null
        // int32
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0xFF] // 255, big-endian
        
        // decode
        
        let bundle = try OSCBundle(from: knownGoodOSCRawBytes.data)
        
        #expect(bundle.timeTag.rawValue == 1)
        #expect(bundle.elements.count == 1)
        
        guard case let .message(msg) = bundle.elements.first else { Issue.record(); return }
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val = try #require(msg.values.first as? Int32)
        #expect(val == 255)
        
        // re-encode
        
        #expect(try bundle.rawData() == knownGoodOSCRawBytes.data)
    }
}
