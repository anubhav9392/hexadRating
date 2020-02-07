//
//  DialogBuilder.swift
//  Hexad Rating
//
//  Created by Anubhav Chandra on 6/2/20.
//  Copyright © 2020 Anubhav Chandra. All rights reserved.
//

import Foundation
import UIKit
protocol DialogDelegate {
    func showDialog(title:String,message:String)
}

class DialogBuilder{
  var alert:UIAlertController!
    init(title: String, message: String) {
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

//             add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    }
    func getAlert()->UIAlertController{
        return alert
    }
}
