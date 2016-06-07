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
        HUD.show(.Loading, text: "Loading...", time: 3)
    }
    
    @IBAction func successHandler(sender: AnyObject) {
        HUD.show(.Success, text: "Success")
    }
    
    @IBAction func errorHandler(sender: AnyObject) {
        HUD.show(.Error, text: "Error")
    }
   
    
    @IBAction func infohandler(sender: AnyObject) {
        HUD.show(.Info, text: "Warning")
    }
    
    @IBAction func textHandler(sender: AnyObject) {
        HUD.show(.None, text: "Text...")
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

