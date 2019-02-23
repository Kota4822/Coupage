//
//  UserConfig.swift
//  Coupage
//
//  Created by Takumi Karibe on 2019/02/23.
//

import Foundation

public struct UserConfig {
    let name: String
    let password: String
    let url: URL
}

extension UserConfig {
    init?(name: String, password: String, urlString: String) {
        guard let url = URL(string: urlString) else { return nil }
        self.init(name: name, password: password, url: url)
    }
}
