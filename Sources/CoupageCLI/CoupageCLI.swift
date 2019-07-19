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
    enum Reserved: String, CaseIterable {
        case pageTitle, templateName, spaceKey, ancestorsKey
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
        let sampleTmplFileName = "\(sampleDirName)/template.tpl"
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
            print("🍻 completed!!!")
            
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
    
    public static func run(_ args: [String]) {
        let (reservedAuguments, templateAuguments) = parse(args: args)
        
        guard let pageTitle = reservedAuguments[.pageTitle], let templateName = reservedAuguments[.templateName] else {
            fatalError("⛔️ pageTitle/templateNameが存在しません")
        }
        
        let config = ConfigLoader.loadConfig(templateName: templateName)
        let confluence = Config.Page(url: config.page.url,
                                     spaceKey: reservedAuguments[.spaceKey] ?? config.page.spaceKey,
                                     ancestorsKey: reservedAuguments[.ancestorsKey] ?? config.page.ancestorsKey)
        
        var template = TemplateLoader.fetchTemplate(templateName: templateName)
        templateAuguments.forEach { key, value in
            template = template.replacingOccurrences(of: "{{\(key)}}", with: value)
        }
        
        let page = CoupagePage(title: pageTitle, body: template, config: confluence)
        PageGenerator.generate(page: page, user: config.user)
    }
}

private extension CoupageCLI {
    static func parse(args: [String]) -> ([Reserved: String], [String: String]) {
        var reservedAuguments: [Reserved: String] = [:]
        var templateAuguments: [String: String] = [:]
        
        args.filter{ $0.contains(":") }
            .compactMap { $0.split(separator: ":").map(String.init) }
            .forEach { arg in
                if let reservedkey = Reserved(rawValue: arg[0]) {
                    reservedAuguments[reservedkey] = arg[1]
                } else {
                    templateAuguments[arg[0]] = arg[1]
                }
        }
        
        return (reservedAuguments, templateAuguments)
    }
}

