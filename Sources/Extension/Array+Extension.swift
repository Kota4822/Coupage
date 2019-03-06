//
//  Array+Extension.swift
//  CYaml
//
//  Created by kota-otsu on 2019/03/06.
//

import Foundation

extension Array {
   public subscript(safe index: Int?) -> Element? {
        guard let index = index, 0..<self.count ~= index else {
            return nil
        }
        
        return self[index]
    }
}
