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
    
    public static func initialize() {
        let configDirName = ".coupage"
        let userConfigContents = """
                                id:
                                password:
                                """.data(using: .utf8)
        
        let userConfigFileName = "\(configDirName)/user_config.yml"
        let templateDirName = "\(configDirName)/templates"
        
        let sampleDirName = "\(templateDirName)/sample"
        let sampleTmplFileName = "\(sampleDirName)/sample.tpl"
        let sampleTmplContents = "<title>{{Title}}</title>".data(using: .utf8)
        let sampleYmlFileName = "\(sampleDirName)/page_config.yml"
        let sampleYmlContents = """
                               url: https://hoge.com/fuga/piyo
                               default_space_key:
                               default_ancestors_key:
                               """.data(using: .utf8)
        
        do {
            try FileManager.default.createDirectory(atPath: configDirName, withIntermediateDirectories: true, attributes: nil)
            _ = FileManager.default.createFile(atPath: userConfigFileName, contents: userConfigContents, attributes: nil)
            
            try FileManager.default.createDirectory(atPath: templateDirName, withIntermediateDirectories: true, attributes: nil)
            
            try FileManager.default.createDirectory(atPath: sampleDirName, withIntermediateDirectories: true, attributes: nil)
            
            _ = FileManager.default.createFile(atPath: sampleTmplFileName, contents: sampleTmplContents, attributes: nil)
            _ = FileManager.default.createFile(atPath: sampleYmlFileName, contents: sampleYmlContents, attributes: nil)
            
        } catch {
            try? FileManager.default.removeItem(atPath: configDirName)
            try? FileManager.default.removeItem(atPath: userConfigFileName)
            try? FileManager.default.removeItem(atPath: templateDirName)
            try? FileManager.default.removeItem(atPath: sampleDirName)
            try? FileManager.default.removeItem(atPath: sampleTmplFileName)
            try? FileManager.default.removeItem(atPath: sampleYmlFileName)
            fatalError("⛔️ failed to create config files")
        }
    }
}
