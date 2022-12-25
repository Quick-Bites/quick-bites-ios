//
//  KeychainService.swift
//  Quick-Bites
//
//  Created by Can Usluel on 24.12.2022.
//

import Foundation

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case itemNotFound
    case unhandledError(status: OSStatus)
}

class KeychainWrapper {
    
    func addItem(account:String, service: String, password: String) throws{
        if password.isEmpty {
          try deleteItem(
            account: account,
            service: service)
          return
        }
        guard let passwordData = password.data(using: .utf8) else {
            print("Error in converting value to data.")
            throw KeychainError.unexpectedPasswordData
        }

        let query: [String:Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                   kSecAttrService as String: service,
                                    kSecValueData as String: passwordData]
        let status = SecItemAdd(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
          break
        case errSecDuplicateItem:
          try updateItem(
            account: account,
            service: service,
            password: password)

        default:
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func searchItem(account: String, service: String) throws -> String{
        let query: [String: Any] = [
            // 1
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            // 2
            kSecMatchLimit as String: kSecMatchLimitOne,
            // 3
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
          ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.itemNotFound }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard
          let existingItem = item as? [String: Any],
          let valueData = existingItem[kSecValueData as String] as? Data,
          let value = String(data: valueData, encoding: .utf8)
          else {
            throw KeychainError.unexpectedPasswordData
        }

        return value
    }

    func updateItem(
      account: String,
      service: String,
      password: String
    ) throws {
      guard let passwordData = password.data(using: .utf8) else {
        print("Error in converting value to data.")
        return
      }
      let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: account,
        kSecAttrService as String: service
      ]

      let attributes: [String: Any] = [
        kSecValueData as String: passwordData
      ]

      let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
      guard status != errSecItemNotFound else {
          throw KeychainError.unexpectedPasswordData
      }
      guard status == errSecSuccess else {
          throw KeychainError.unhandledError(status: status)
      }
    }
    func deleteItem(account: String, service: String) throws {
      let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: account,
        kSecAttrService as String: service
      ]

      let status = SecItemDelete(query as CFDictionary)
      guard status == errSecSuccess || status == errSecItemNotFound else {
          throw KeychainError.unhandledError(status: status)
      }
    }
}

