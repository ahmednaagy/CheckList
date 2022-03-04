//
//  Checklist.swift
//  CheckList
//
//  Created by Ahmed Nagy on 21/02/2022.
//

import UIKit

class Checklist: NSObject {
    var name: String
    var items = [ChecklistItem]()
    init(name: String) {
        self.name = name
        super.init()
    }
}
