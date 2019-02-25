//
//  TemplateLoader.swift
//  Coupage
//
//  Created by Takumi Karibe on 2019/02/23.
//

import Foundation

public struct TemplateLoader {
    private init() {}

    public static func fetchTemplate() -> String {

        // TODO: templeteのfilename/pathを決める
        let dir = FileManager.default.currentDirectoryPath + "/Template.tpl"

        if !FileManager.default.fileExists(atPath: dir) {
            fatalError("⛔️ Templateファイルが存在しません")
        }
        
        guard let file = FileManager.default.contents(atPath: dir), let contents = String(data: file, encoding: .utf8) else {
            fatalError("⛔️ Templateファイルが不正です")
        }
        
        return contents
    }
}
