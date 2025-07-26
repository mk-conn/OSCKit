//
//  OSCAddressPattern init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if compiler(>=6.0)
internal import SwiftASCII // ASCIIString
#else
@_implementationOnly import SwiftASCII // ASCIIString
#endif

extension OSCAddressPattern {
    /// Create an OSC address from a raw `String` address.
    /// The string will be converted to valid ASCII, lossily converting or removing invalid
    /// non-ASCII characters if necessary.
    public init(_ lossy: String) {
        let asciiLossy = ASCIIString(lossy)
        self.init(ascii: asciiLossy)
    }
    
    /// Internal:
    /// Create an OSC address from a raw `ASCIIString` address.
    init(ascii address: ASCIIString) {
        rawAddress = address.stringValue
        rawData = address.rawData
    }
    
    /// Create an OSC address from individual path components.
    /// The path component strings will be converted to valid ASCII, lossily converting or removing
    /// invalid non-ASCII characters if necessary.
    /// An empty path components sequence is equivalent to the address of "/".
    public init<S>(pathComponents lossy: S) where S: BidirectionalCollection,
        S.Element: StringProtocol
    {
        let formedAddress = ("/" + lossy.joined(separator: "/"))
        self.init(formedAddress)
    }
    
    /// Internal:
    /// Create an OSC address from individual path components.
    /// The path component strings will be converted to ASCII strings, lossily converting or
    /// removing invalid non-ASCII characters if necessary.
    /// An empty path components sequence is equivalent to the address of "/".
    init<S>(asciiPathComponents: S) where S: BidirectionalCollection, S.Element == ASCIIString {
        let ascii = ASCIICharacter("/") + asciiPathComponents.joined(separator: "/")
        self.init(ascii: ascii)
    }
}
