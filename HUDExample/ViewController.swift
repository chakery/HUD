//
//  ViewController.swift
//  HUDExample
//
//  Created by Chakery on 16/4/7.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func loadingHandler(sender: AnyObject) {
        HUD.show(.loading, text: "Loading...", time: 3)
    }
    
    @IBAction func successHandler(sender: AnyObject) {
        HUD.show(.success, text: "Success")
    }
    
    @IBAction func errorHandler(sender: AnyObject) {
        HUD.show(.error, text: "Error")
    }
   
    
    @IBAction func infohandler(sender: AnyObject) {
        HUD.show(.info, text: "Warning")
    }
    
    @IBAction func textHandler(sender: AnyObject) {
        HUD.show(.none, text: "Text...")
    }
    
    @IBAction func dismissHandler(sender: AnyObject) {
        HUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

