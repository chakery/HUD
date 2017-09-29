//
//  ViewController.swift
//  HUDExample
//
//  Created by Chakery on 16/4/7.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func loadingHandler(_ sender: UIButton) {
        HUD.show(.loading, text: "Loading...", time: 3)
    }
    
    @IBAction func successHandler(_ sender: UIButton) {
        HUD.show(.success, text: "Success")
    }
    
    @IBAction func errorHandler(_ sender: UIButton) {
        HUD.show(.error, text: "Error")
    }
    
    @IBAction func infohandler(_ sender: UIButton) {
        HUD.show(.info, text: "Warning")
    }
    
    @IBAction func textHandler(_ sender: UIButton) {
        HUD.show(.none, text: "Text...")
    }
    
    @IBAction func dismissHandler(_ sender: UIButton) {
        HUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

