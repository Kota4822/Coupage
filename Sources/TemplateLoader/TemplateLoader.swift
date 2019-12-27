//
//  TemplateLoader.swift
//  Coupage
//
//  Created by Takumi Karibe on 2019/02/23.
//

import Foundation

public struct TemplateLoader {
    private init() {}

    public static func fetchTemplate(templateName: String) -> String {
        let path = templatePath(for: templateName)
        
        if !FileManager.default.fileExists(atPath: path) {
            fatalError("⛔️ Templateファイルが存在しません path > \(path)")
        }
        
        guard let file = FileManager.default.contents(atPath: path), let contents = String(data: file, encoding: .utf8) else {
            fatalError("⛔️ Templateファイルが不正です")
        }
        
        return contents
    }
}

private extension TemplateLoader {
    static var rootPath: String {
        return FileManager.default.currentDirectoryPath + "/.coupage"
    }
    
    static func templatePath(for template: String) -> String {
        return [rootPath, "templates", template, "template.tpl"].joined(separator: "/")
    }
}
