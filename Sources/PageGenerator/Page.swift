//
//  Page.swift
//  CYaml
//
//  Created by kota-otsu on 2019/03/06.
//

import Foundation
import Config

public struct Page {
    let title: String
    let body: String
    // TODO: 名前に違和感
    let config: Config.Confluence
    
    public init(title: String, body: String, config: Config.Confluence) {
        self.title = title
        self.body = body
        self.config = config
    }
}
