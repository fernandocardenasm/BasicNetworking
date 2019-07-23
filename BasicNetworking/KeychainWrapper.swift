//
//  KeychainWrapper.swift
//  BasicNetworking
//
//  Created by Fernando Cardenas on 23.07.19.
//

import Foundation

/// Types that conform to Keychain can create, store and delete keys for the iOS Keychain.
protocol Keychain {
    /// Returns a dictionary of all keychain entries matching the class kSecClassGenericPassword
    func allKeychainItems() -> [String: String]

    /// Returns a string value for a specified key.
    ///
    /// - parameter forKey: The key to lookup data for.
    /// - returns: The String associated with the key if it exists. If no data exists, or the data found cannot be encoded as a string, returns nil.
    func retrieveString(forKey: String) -> String?

    /// Saves a String value to the keychain associated with a specified key. If a String value already exists for the given key, the string will be overwritten with the new value.
    ///
    /// - parameter value: The String value to save.
    /// - parameter forKey: The key to save the String under.
    /// - returns: True if the save was successful, false otherwise.
    @discardableResult
    func set(_ value: String, forKey: String) -> Bool

    /// Removes an object associated with a specified key.
    ///
    /// - parameter forKey: The key value to remove data for.
    /// - returns: True if successful, false otherwise.
    @discardableResult
    func removeObject(forKey: String) -> Bool

    /// Removes all the key-value pairs.
    ///
    /// - returns: True if successful, false otherwise.
    @discardableResult
    func clear() -> Bool
}

/// A simple wrapper for the iOS Keychain.
final class KeychainWrapper: Keychain {
    /// Default keychain wrapper access. When used the Service Name is "SharedKeychainWrapper".
    static let shared = KeychainWrapper(serviceName: "SharedKeychainWrapper")

    /// ServiceName is used for the kSecAttrService property to uniquely identify this keychain accessor.
    let serviceName: String

    init(serviceName: String) {
        self.serviceName = serviceName
    }

    func allKeychainItems() -> [String: String] {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: serviceName,
                                    kSecReturnData as String: kCFBooleanTrue as Any,
                                    kSecReturnAttributes as String: kCFBooleanTrue as Any,
                                    kSecMatchLimit as String: kSecMatchLimitAll]
        var result: AnyObject?

        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        guard lastResultCode == noErr,
            let resultArray = result as? [[String: Any]] else {
                return [:]
        }
        var values = [String: String]()

        // The approach of using compactMap and then flatMap was tried, but then I ended up with an dict of type Dictionary, which I also needed
        // to transform to [String: String]. I considered that the code would not have not been very understandable. For clarity, the following approach
        // was taken.
        resultArray.forEach { item in
            guard let key = item[kSecAttrGeneric as String] as? Data,
                let value = item[kSecValueData as String] as? Data else {
                    return
            }
            values[String(data: key, encoding: .utf8)!] = String(data: value, encoding: .utf8)
        }
        return values
    }

    func retrieveString(forKey key: String) -> String? {
        guard let keyData = key.data(using: .utf8, allowLossyConversion: false) else {
            return nil
        }
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrService: serviceName,
                                      kSecAttrGeneric: keyData,
                                      kSecAttrAccount: keyData,
                                      kSecReturnData: kCFBooleanTrue as Any,
                                      kSecMatchLimitOne: kSecMatchLimitOne]
        var dataTypeRef: AnyObject?

        SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard let retrievedData = dataTypeRef as? Data else {
            return nil
        }
        return String(data: retrievedData, encoding: .utf8)
    }

    func set(_ value: String, forKey key: String) -> Bool {
        // This conversation should never fail.
        // More info:  https://stackoverflow.com/questions/46152617/can-the-conversion-of-a-string-to-data-with-utf-8-encoding-ever-fail
        guard let valueData = value.data(using: .utf8, allowLossyConversion: false),
            let keyData = key.data(using: .utf8, allowLossyConversion: false) else {
                return false
        }
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrService: serviceName,
                                      kSecAttrGeneric: keyData,
                                      kSecAttrAccount: keyData,
                                      kSecValueData: valueData]
        let status = SecItemAdd(query as CFDictionary, nil)

        switch status {
        case errSecSuccess:
            return true
        case errSecDuplicateItem:
            return updateItem(withData: valueData, initialQuery: query)
        default:
            return false
        }
    }

    func removeObject(forKey key: String) -> Bool {
        guard let keyData = key.data(using: .utf8, allowLossyConversion: false) else {
            return false
        }
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrService: serviceName,
                                      kSecAttrGeneric: keyData,
                                      kSecAttrAccount: keyData]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess else {
            return false
        }
        return true
    }

    func clear() -> Bool {
        // In case that there are no items, it is more intuitive that the method returns true because the items is already empty.
        guard !allKeychainItems().isEmpty else {
            return true
        }
        guard SecItemDelete([kSecClass: kSecClassGenericPassword,
                             kSecAttrService: serviceName] as NSDictionary) == errSecSuccess else {
                                return false
        }
        return true
    }

    private func updateItem(withData data: Data, initialQuery: [CFString: Any]) -> Bool {
        guard SecItemUpdate(initialQuery as CFDictionary,
                            [kSecValueData: data] as CFDictionary) == errSecSuccess else {
                                return false
        }
        return true
    }
}
