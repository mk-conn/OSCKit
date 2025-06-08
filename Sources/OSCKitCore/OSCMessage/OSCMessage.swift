//
//  OSCMessage.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// OSC Message.
///
/// An OSC message contains an address pattern string, and zero or more values.
/// An OSC message may be sent to a recipient by itself, or one or more messages may be packed into
/// an OSC bundle and sent in a single packet.
public struct OSCMessage: OSCObject {
    public static let oscObjectType: OSCObjectType = .message
    
    /// OSC message address pattern.
    public var addressPattern: OSCAddressPattern
    
    /// OSC values (arguments) contained within the message.
    public var values: OSCValues
    
    @usableFromInline
    let _rawData: Data?
}

// MARK: - Equatable

extension OSCMessage: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.addressPattern == rhs.addressPattern &&
            lhs.values == rhs.values
    }
}

// MARK: - Hashable

extension OSCMessage: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(addressPattern.stringValue)
        values.hash(into: &hasher)
    }
}

// MARK: - Sendable

extension OSCMessage: Sendable { }

// MARK: - CustomStringConvertible

extension OSCMessage: CustomStringConvertible {
    public var description: String {
        values.isEmpty
            ? "OSCMessage(\(addressPattern.stringValue.quoted))"
            : "OSCMessage(\(addressPattern.stringValue.quoted), values: \(values))"
    }
    
    /// Same as `description` but values are separated with new-line characters and indented.
    public var descriptionPretty: String {
        values.isEmpty
            ? "OSCMessage(\(addressPattern.stringValue.quoted))"
            : "OSCMessage(\(addressPattern.stringValue.quoted)) with values:\n  "
                + values.map { "\(type(of: $0)): \($0)" }.joined(separator: "\n  ")
                .trimmed
    }
}

// MARK: - Header

extension OSCMessage {
    /// Constant caching an OSCMessage header.
    public static let header: Data = "/".toData(using: .nonLossyASCII) ?? Data()
}

// MARK: - Codable

// TODO: Codable - fix or remove; would require OSCValue to conform to Codable too

// extension OSCMessage: Codable {
//    enum CodingKeys: String, CodingKey {
//        case address
//        case values
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let address = try container.decode(OSCAddressPattern.self, forKey: .address)
//        let values = try container.decode(OSCValues.self, forKey: .values)
//        self.init(address: address, values: values)
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(address, forKey: .address)
//        try container.encode(values, forKey: .values)
//    }
// }
