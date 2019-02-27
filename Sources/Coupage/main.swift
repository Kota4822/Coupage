//
//  main.swift
//  Coupage
//
//  Created by Kota4822 on 2019/02/23.
//

import ConfigLoader
import TemplateLoader
import PageGenerator
import UserConfig

func run() {
    print("🍐 Start Generate Confluence Page")
    
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
