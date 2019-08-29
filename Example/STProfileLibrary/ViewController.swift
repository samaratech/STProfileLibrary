//
//  ViewController.swift
//  STProfileLibrary
//
//  Created by Farmoodhipl on 08/20/2019.
//  Copyright (c) 2019 Farmoodhipl. All rights reserved.
//

import UIKit
import STProfileLibrary

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func callProfile(){
        let appdel = UIApplication.shared.delegate as! AppDelegate
        AppWindow.shared.setWidow(windo: appdel.window!)
        let podBundle = Bundle(for: HomeProfileVC.self)
        let story = UIStoryboard(name: "Main", bundle: podBundle)
        let obj = story.instantiateViewController(withIdentifier: "HomeProfileVC") as! HomeProfileVC
        obj.baseUrl_home = "http://tessapp.tess360.com/"
        obj.LOCATION_ID_home = "66"
        obj.ORG_ID_home = "93"
        obj.SIGNIN_TYPE_home = "P"
        obj.TOKEN_home = "d9b2c69592d7eafa0bdbe6d36e60dc19"
        self.navigationController?.pushViewController(obj, animated: true)
        
        //["TOKEN": "d9b2c69592d7eafa0bdbe6d36e60dc19", "ORG_ID": "93", "LOCATION_ID": "66", "SIGNIN_TYPE": "P"]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

