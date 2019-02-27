//
//  Config.swift
//  Coupage
//
//  Created by Takumi Karibe on 2019/02/23.
//

import Foundation

public struct Config {
    public struct User {
        public let name: String
        public let password: String
        
        public init(name: String, password: String) {
            self.name = name
            self.password = password
        }
    }
    
    public struct Confluence {
        public let url: URL
        public let spaceKey: String
        public let ancestorsKey: String?
        
        public init(url: URL, spaceKey: String, ancestorsKey: String) {
            self.url = url
            self.spaceKey = spaceKey
            self.ancestorsKey = ancestorsKey.isEmpty ? nil : ancestorsKey
        }
    }
    
    public let user: User
    public let confluence: Confluence
    
    public init(user: User, confluence: Confluence) {
        self.user = user
        self.confluence = confluence
    }
}
