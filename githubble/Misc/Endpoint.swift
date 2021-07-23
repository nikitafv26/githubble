//
//  UrlComponent.swift
//  githubble
//
//  Created by Nikita Fedorenko on 16.07.2021.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem]?
}

extension Endpoint{
    var url: URL?{
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
