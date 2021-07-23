//
//  Repo.swift
//  githubble
//
//  Created by Nikita Fedorenko on 15.07.2021.
//

import Foundation

struct RepoResponse: Codable{
    let count: Int?
    let items: [Repo]?
    
    enum CodingKeys: String, CodingKey {
        case count = "total_count"
        case items
    }
}

struct Repo: Codable {
    let name: String?
    let fullName: String?
    let description: String?
    let owner: Owner?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case fullName = "full_name"
        case description = "description"
        case owner = "owner"
    }
}

struct Owner: Codable {
    let login: String?
    
    enum CodingKeys: String, CodingKey {
        case login
    }
}
