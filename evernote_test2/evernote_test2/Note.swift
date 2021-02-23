//
//  Note.swift
//  evernote_test2
//
//  Created by 石田洋輔 on 2021/02/20.
//

import Foundation
import UIKit
struct Note {
    var title:String = "新しいノート"
    var contents:[Any]
}

struct TableResourceModel {
     var prefectureNames = [
        "北海道",
        "青森県",
       "鹿児島県",
        "沖縄県"
    ]
}

extension TableResourceModel {
    func dragItem(for indexPath: IndexPath) -> UIDragItem {
        let prefectureName = prefectureNames[indexPath.row]
        let itemProvider = NSItemProvider(object: prefectureName as NSString)
        return UIDragItem(itemProvider: itemProvider)
    }
    mutating func moveItem(sourcePath: Int, destinationPath: Int) {
          let prefecture = prefectureNames.remove(at: sourcePath)
          prefectureNames.insert(prefecture, at: destinationPath)
      }
    mutating func remove(at:Int){
        prefectureNames.remove(at: at)
    }
    mutating func update(sourcePath: Int, text:String){
        prefectureNames[sourcePath] = text
    }
}
