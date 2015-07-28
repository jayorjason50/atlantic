//
//  ViewController.swift
//  miQuiz
//
//  Created by Jason Spence on 27/07/2015.
//  Copyright (c) 2015 Jason Spence. All rights reserved.
//

import UIKit

class ViewController: UIViewController {



    @IBAction func toggleLoginView(sender: AnyObject) {
        var toggle = LoginView.viewWithTag(0)?.hidden
        if toggle == true{
            LoginView.viewWithTag(0)?.hidden = false}
        else {LoginView.viewWithTag(0)?.hidden = true}
    }
   
    @IBOutlet weak var LoginView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

