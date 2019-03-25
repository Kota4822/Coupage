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
    let config: Config.Page
    
    public init(title: String, body: String, config: Config.Page) {
        self.title = title
        self.body = body
        self.config = config
    }
}

