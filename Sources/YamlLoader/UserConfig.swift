//
//  UserConfig.swift
//  Coupage
//
//  Created by Takumi Karibe on 2019/02/23.
//

import Foundation

public struct UserConfig {
    public static var shared: UserConfig = YamlLoader.loadConfig()
    public let name: String
    public let password: String
    public let url: URL
    private init(name: String, password: String, url: URL) {
        self.name = name
        self.password = password
        self.url = url
    }
}

extension UserConfig {
    init?(name: String? = nil, password: String? = nil, urlString: String? = nil) {
        guard let name = name, !name.isEmpty, let password = password, !password.isEmpty, let urlString = urlString, let url = URL(string: urlString) else {
            return nil
        }
        
        self.init(name: name, password: password, url: url)
    }
}
