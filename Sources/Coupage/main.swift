//
//  main.swift
//  Coupage
//
//  Created by Kota4822 on 2019/02/23.
//

import YamlLoader
import ConfigLoader
import TemplateLoader
import UserConfig

func run() {
    print("🍐 Start Generate Confluence Page")
    
    guard CommandLine.arguments.count >= 2 else {
        print("⛔️ 引数が不足しています >>> \(CommandLine.arguments)")
        assertionFailure()
        return
    }
    
    // TODO: 外部から引数で受け取る
    // 対象のspacekey
    let spaceKey = "spaceKey"
    
    // TODO: 外部から引数で受け取る
    // 対象の親ページID(optional)
    let ancestorsKey = "ancestorsKey"

    // TODO: 外部から引数で受け取る
    // 生成するpegeのtitle
    let pageTitle = "pageTitle"
    
    let userConfig = UserConfigLoader.loadConfig()
    
    let template = TemplateLoader.fetchTemplate()
}

run()
