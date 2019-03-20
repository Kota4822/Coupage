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

public struct CoupageCLI {

    public struct Parameter {
        let title: String
        let spaceKey: String?
        let ancestorsKey: String?
        let templateAuguments: [String: String]
        
        public init(title: String, spaceKey: String?, ancestorsKey: String?, templateAuguments: [String: String]){
            self.title = title
            self.spaceKey = spaceKey
            self.ancestorsKey = ancestorsKey
            self.templateAuguments = templateAuguments
        }
    }
    
    public static func execute(_ parameter: Parameter) {

        let spaceKey = parameter.spaceKey
        let ancestorsKey = parameter.ancestorsKey

        let config = ConfigLoader.loadConfig()
        let template = TemplateLoader.fetchTemplate()

        let confluence = Config.Page(url: config.page.url,
                                     spaceKey: spaceKey ?? config.page.spaceKey,
                                     ancestorsKey: ancestorsKey ?? config.page.ancestorsKey)

        var replacedTemplate = template
        parameter.templateAuguments.forEach { key, value in
            replacedTemplate = replacedTemplate.replacingOccurrences(of: "{{\(key)}}", with: value)
        }
        
        let page = Page(title: parameter.title, body: replacedTemplate, config: confluence)
        PageGenerator.generate(page: page, user: config.user)
    }
}
