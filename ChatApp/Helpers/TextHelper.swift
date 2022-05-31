//
//  TextHelper.swift
//  ChatApp
//
//  Created by Vu Trinh on 5/31/22.
//

import Foundation

class TextHelper {
    static func sanitizePhoneNumber(phone: String) -> String {
        return phone
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
}
