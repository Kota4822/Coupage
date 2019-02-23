//
//  UserConfig.swift
//  Coupage
//
//  Created by Takumi Karibe on 2019/02/23.
//

import Foundation

public struct UserConfig {
    public static var shared = YamlLoader.loadConfig()
    
    public let name: String
    public let password: String
    public let url: URL
    
    init(name: String, password: String, url: URL) {
        self.name = name
        self.password = password
        self.url = url
    }
}
