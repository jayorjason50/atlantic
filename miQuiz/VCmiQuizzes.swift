//
//  VCmiQuizzes.swift
//  miQuiz
//
//  Created by Liam on 27/07/2015.
//  Copyright (c) 2015 Jason Spence. All rights reserved.
//

import UIKit

class VCmiQuizzes: UIViewController , UITableViewDataSource, UITableViewDelegate{
    var miQuizzes: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "miQuizzes"
        
        var snapshot: FDataSnapshot = FDataSnapshot()
        var ref = Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes")
        
        
        ref.observeEventType(.ChildAdded, withBlock: {snapshot in
            
            
            self.miQuizzes.addObject(snapshot.key)
            self.tableView.reloadData()
        })
        
        ref.observeEventType(.ChildRemoved, withBlock: {snapshot in
            
            
            self.miQuizzes.removeObject(snapshot.key)
            self.tableView.reloadData()
        })
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return miQuizzes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        let (MiQuizTitle: AnyObject) = miQuizzes[indexPath.row]
        cell.textLabel?.text = MiQuizTitle as? String
        var myImage = UIImage(named: "CellIcon")
        cell.imageView?.image = myImage
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Values to index into the array holding the data
        let row = indexPath.row
        let section = indexPath.section
        let quiz = (miQuizzes[indexPath.row] as! String) //Get string representation of the cells text
        
        //Make a reference to the VCMyQuizzesDetail (It's Identifier is set via storyboard -> ID card icon -> Identifier
        var view: VCmiQuizzesDetail = self.storyboard?.instantiateViewControllerWithIdentifier("VCmiQuizzesDetail") as! VCmiQuizzesDetail
        //Set the animation
        self.navigationController?.pushViewController(view, animated: true)
        view.title = miQuizzes[indexPath.row] as? String //Set the text
        
        
        
        
    }
    
    

   
}
