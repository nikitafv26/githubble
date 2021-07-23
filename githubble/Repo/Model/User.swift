//
//  User.swift
//  githubble
//
//  Created by Nikita Fedorenko on 18.07.2021.
//

import Foundation

struct User: Codable {
    let login: String?
    let name: String?
    let email: String?
    
    enum CodingKeys: String, CodingKey {
        case login, name, email
    }
}
