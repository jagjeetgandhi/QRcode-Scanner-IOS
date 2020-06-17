//
//  ViewController.swift
//  QRcode
//
//  Created by jagjeet on 25/02/20.
//  Copyright © 2020 jagjeet. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 13.0, *)
class ViewController: UIViewController {

    @IBAction func scan(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let QRVC = story.instantiateViewController(identifier: "QRscannerViewController") as! QRscannerViewController
        self.navigationController?.pushViewController(
            QRVC, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

