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
    var theTitle = ""
    var path = NSIndexPath()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var plus: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        plus.action = "addQuiz:"
        plus.target = self
        var purple = UIColor(red:(84/255),green:(0/255),blue:(79/255),alpha:1.0)
       
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:UIControlState.Normal)
        
        navigationController?.navigationBar.barTintColor = purple
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
//        navigationItem.leftBarButtonItem = backButton
        
//        var newQuiz = UIBarButtonItem(title: "Add Quiz", style: .Plain, target: self, action:"addQuiz:")
//        navigationItem.rightBarButtonItem = newQuiz
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
        
        
        let newTitle = (miQuizzes[indexPath.row] as? String)!

        
        // Create an instance of PlayerTableViewController and pass the variable
        let destinationVC = VCmiQuizzesDetail()
        destinationVC.newTitle = newTitle
       
        
        
    
        theTitle =  (miQuizzes[indexPath.row] as? String)!
        
        
        //Values to index into the array holding the data
        let row = indexPath.row
        let section = indexPath.section
        let quiz = (miQuizzes[indexPath.row] as! String) //Get string representation of the cells text
        
        //Make a reference to the VCMyQuizzesDetail (It's Identifier is set via storyboard -> ID card icon -> Identifier
        
        
//        var view: VCmiQuizzesDetail = self.storyboard?.instantiateViewControllerWithIdentifier("VCmiQuizzesDetail") as! VCmiQuizzesDetail
//        //Set the animation
//        self.navigationController?.pushViewController(view, animated: true)
//        view.title = miQuizzes[indexPath.row] as? String //Set the text
//        view.name =  (miQuizzes[indexPath.row] as? String)!
        
        
        
    }
    func addQuiz(sender:UIBarButtonItem){
    
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Create New Quiz",
            message: "",
            preferredStyle: .Alert)
        
        alertController!.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = "Quiz Title"
        })
        alertController?.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: {[weak self]
            (paramAction:UIAlertAction!) in
            
            }))
        alertController?.addAction(UIAlertAction(title: "Submit",
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                if let textFields = alertController?.textFields{
                    let theTextFields = textFields as! [UITextField]
                    let enteredText = theTextFields[0].text
                    var roundRef =  Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes/\(enteredText)/Round 1")
                    let post1 = ["Holder": "Holder"]
                    let post1Ref = roundRef.childByAutoId()
                    post1Ref.setValue(post1)
                    
                    var view: VCmiQuizzesDetail = self!.storyboard?.instantiateViewControllerWithIdentifier("VCmiQuizzesDetail") as! VCmiQuizzesDetail
                    //Set the animation
                    view.title = "\(enteredText)"
                    self!.navigationController?.pushViewController(view, animated: true)
                    
                    
                    
                    
                }
            }))
        
        
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)

    
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        path = indexPath
        return indexPath
    }
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "toDetail"{
        var dest = segue.destinationViewController as! VCmiQuizzesDetail
        dest.title = miQuizzes[path.row] as? String
    }
  }
    

   
}
