//
//  Config.swift
//  Coupage
//
//  Created by Takumi Karibe on 2019/02/23.
//

import Foundation

public struct Config {
    public struct User {
        public let id: String
        public let apiKey: String
        
        public init(id: String, apiKey: String) {
            self.id = id
            self.apiKey = apiKey
        }
    }
    
    public struct Page {
        public let url: URL
        public let spaceKey: String
        public let ancestorsKey: String?
        
        public init(url: URL, spaceKey: String, ancestorsKey: String?) {
            self.url = url
            self.spaceKey = spaceKey
            self.ancestorsKey = ancestorsKey?.isEmpty == true ? nil : ancestorsKey
        }
    }
    
    public let user: User?
    public let page: Page
    
    public init(user: User?, page: Page) {
        self.user = user
        self.page = page
    }
}
