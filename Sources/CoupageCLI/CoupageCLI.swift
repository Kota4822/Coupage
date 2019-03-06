//
//  CoupageCLI.swift
//  CYaml
//
//  Created by kota-otsu on 2019/03/06.
//

import Foundation
import Config
import ConfigLoader
import TemplateLoader
import PageGenerator
import Extension

public struct CoupageCLI {
    
    public static func execute(auguments: [String]? = nil) {

        let spaceKey = auguments?[safe: 1]
        let ancestorsKey = auguments?[safe: 2]

        let config = ConfigLoader.loadConfig()
        let template = TemplateLoader.fetchTemplate()

        let confluence = Config.Confluence(url: config.confluence.url,
                                           spaceKey: spaceKey ?? config.confluence.spaceKey,
                                           ancestorsKey: ancestorsKey ?? config.confluence.ancestorsKey)
        
        let page = Page(title: "aaa", body: template, config: confluence)
        PageGenerator.generate(page: page, user: config.user)
    }
    
}
