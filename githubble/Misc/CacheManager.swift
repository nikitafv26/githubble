//
//  Storage.swift
//  githubble
//
//  Created by Nikita Fedorenko on 18.07.2021.
//

import Foundation
import Cache

struct CacheManager {
    static let shared = CacheManager()
    
    var storage: Storage<String, [Repo]>? = {
        let storage = try? Storage<String, [Repo]>(
            diskConfig: DiskConfig(name: "Githubble"),
            memoryConfig: MemoryConfig(),
            transformer: TransformerFactory.forCodable(ofType: [Repo].self))
        return storage
    }()
}
