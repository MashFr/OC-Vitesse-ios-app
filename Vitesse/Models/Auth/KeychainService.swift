//
//  KeychainService.swift
//  Vitesse
//
//  Created by Tony Stark on 09/12/2024.
//

import Foundation

enum KeychainError: Error {
    case duplicateItem
    case itemNotFound
    case unexpectedSendingData
    case unexpectedResponseData
    case unhandledError(status: OSStatus)
}

class KeychainService {

    init() {}

    func save(_ value: String, forKey key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.unexpectedSendingData
        }

        // Create a dictionary to store the data
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        // Add the data to the keychain.
        let status = SecItemAdd(query as CFDictionary, nil)

        guard status != errSecDuplicateItem else {throw KeychainError.duplicateItem }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }

    // MARK: - Update Item
    func update(_ value: String, forKey key: String) throws {

        guard let data = value.data(using: .utf8) else {
            throw KeychainError.unexpectedSendingData
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }

    // MARK: - Create or Update Item
    func saveOrUpdate(_ value: String, forKey key: String) throws {
        do {
            // Try to retrieve the item, if found update it
            _ = try retrieve(forKey: key)
            try update(value, forKey: key)
        } catch KeychainError.itemNotFound {
            // If not found, create a new item
            try save(value, forKey: key)
        } catch {
            throw error
        }
    }

    // MARK: - Retrieve Item
    func retrieve(forKey key: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status != errSecItemNotFound else { throw KeychainError.itemNotFound }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }

        guard let data = result as? Data, let value = String(data: data, encoding: .utf8) else {
            throw KeychainError.unexpectedResponseData
        }

        return value
    }

    // MARK: - Delete Item
    func delete(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
}
