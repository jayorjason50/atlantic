//
//  VCmiQuizzesDetail.swift
//  miQuiz
//
//  Created by Jason Spence on 27/07/2015.
//  Copyright (c) 2015 Jason Spence. All rights reserved.
//

import UIKit
var theSelectedName = ""
class VCmiQuizzesDetail: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
        @IBOutlet weak var tableView: UITableView!
    var miQuestions: NSMutableArray = NSMutableArray()
    //var miQuizzes: NSMutableArray = NSMutableArray()
    var miRounds: NSMutableArray = NSMutableArray()
    var roundSec: NSMutableArray = NSMutableArray()
    var arrayInc = 0
    var quiz = ""
    var name = ""
    var newTitle = ""
    var timer: NSTimer!
    var grey = UIColor(red:(204/255),green:(204/255),blue:(204/255),alpha:1.0)
  
    
    @IBAction func showActionSheet(sender: AnyObject) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
       
        let addRound = UIAlertAction(title: "Add Round", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.addRound()
        })
        let addQuestion = UIAlertAction(title: "Add Question", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.addQuestion()
        })
      
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        optionMenu.addAction(addRound)
        optionMenu.addAction(addQuestion)
        optionMenu.addAction(cancel)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        name = self.title!
//        var button = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Bordered, target: self, action: "goBack")
//        self.navigationItem.leftBarButtonItem = button
        
//        var refreshButton = UIBarButtonItem(title: "Add Round", style: .Plain, target: self, action:"addRound:") //Use a selector
//        navigationItem.rightBarButtonItem = refreshButton
        
        
        
        var snapshot: FDataSnapshot = FDataSnapshot()
        var ref = Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes/" + name) //Make ref to the selected quiz
        
        ref.observeSingleEventOfType(.Value, withBlock:{snapshot in
            self.miRounds.addObject(snapshot.childrenCount)
            
            for rest in snapshot.children.allObjects as! [FDataSnapshot]{ //Loop through (nested loop to get to the questions)
                
                var child = rest.children.allObjects
                var round = rest.key
                
                
                
                for rest in child as! [FDataSnapshot]{
                    var child = rest.children.allObjects
                    
                    for rest in child as! [FDataSnapshot]{
                        var questionID = rest.value as! String
                        var ref = Firebase(url:"https://miquiz.firebaseio.com/Questions")
                        ref.observeSingleEventOfType(.Value, withBlock:{snapshot in
                            
                            for rest in snapshot.children.allObjects as! [FDataSnapshot]{
                                var data = rest.value.objectForKey("ID") as! String
                                
                                if(data == questionID){
                                    
                                    //If they match do some splitting of the string: "Round 1" changes to 1, as an int
                                    var roundString = String(round!)
                                    let index = advance(roundString.startIndex, 6)
                                    var newString = roundString.substringFromIndex(index)
                                    
                                    var roundToAdd = newString.toInt()!
                                    self.roundSec.addObject(roundToAdd - 1)//For indexing purposes remove 1
                                    var question = rest.value.objectForKey("Question") as! String
                                    self.miQuestions.addObject(question)
                                    self.tableView.reloadData()
                                    
                                }
                            }
                        })
                    }
                }
                
            }
        })
        
            
        
        
        
        
        // Do any additional setup after loading the view.
    }
//    func goBack(){
//        
//        var view: VCmiQuizzes = self.storyboard?.instantiateViewControllerWithIdentifier("VCmiQuizzes") as! VCmiQuizzes
//        //Set the animation
//        
//      self.navigationController?.pushViewController(view, animated: false)
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var num = 1
        
        for elements in miRounds{
            
            num = elements as! Int //Update to get the number of rounds
            
        }
        
        
        
        
        
        return num
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 0))
        footerView.backgroundColor = grey
        
        
        return footerView
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int)-> String? {
        
        
        return "Round " + String(section + 1)//Get section and and 1 to get round number
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
       let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! CustomHeaderCellTableViewCell
        headerCell.headerLabel.text = "Round " + String(section + 1)
    
        return headerCell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var count = 0
        
        
        
        for elements in roundSec{ //Loop through the rounds array
            
            if elements as! Int == section{ //If it matches the section
                
                count++ //Increment count
            }
            
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell //Make cell
        let (MiQuestionTitle: AnyObject) = miQuestions[arrayInc] //Set the title the next value in the questions array, we are essentially iterating over this
        //As arrayInc is 0 to start the first cell can still use miQuestions[arrayInc]
        
        var count = miQuestions.count //Get the size of the questions array
        
        
        if arrayInc >= count - 1{ //If our counter (arrayInc) reaches or exceeds the size of count we reset the arrayInc value
            
            arrayInc = 0
            
        }
        else{//Otherwise increment
            arrayInc++
        }
        cell.textLabel?.text = MiQuestionTitle as? String //Now set the title and images of the cell
        var myImage = UIImage(named: "CellIcon")
        
        
        
        var snapshot: FDataSnapshot = FDataSnapshot()
        var ref = Firebase(url:"https://miquiz.firebaseio.com/Questions" )
        ref.observeSingleEventOfType(.Value, withBlock:{snapshot in
            
            
            for rest in snapshot.children.allObjects as! [FDataSnapshot]{
                var data = rest.value.objectForKey("Question") as! String
                if data == "\(MiQuestionTitle)"{
                    var cat = rest.value.objectForKey("Category") as! String
                    cell.detailTextLabel?.text = cat
                    cell.detailTextLabel?.hidden = false
                }
                

            }
        
        })
        
        
        
        
        
        cell.imageView?.image = myImage
        
        
        
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func addRound(){
    
        var theRoundVal = (miRounds[miRounds.count - 1] as! Int) + 1
        var roundRef =  Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes/\(self.name)/Round \(theRoundVal)")
        let post1 = ["Holder": "Holder"]
        let post1Ref = roundRef.childByAutoId()
        post1Ref.setValue(post1)
        
       
    }
    
//    func addQuestion(sender:UIButton){
//        var view: VCmiQuizzesDetailAddQuestion = self.storyboard?.instantiateViewControllerWithIdentifier("VCmiQuizzesDetailAddQuestion") as! VCmiQuizzesDetailAddQuestion
//        //Set the animation
//        self.navigationController?.pushViewController(view, animated: true)
//        //view.quizName.text = "Round " +  String(sender.tag)//Set the text
//        view.title = self.title
//        //view.roundName = "Round " +  String(sender.tag)
//        view.roundNameTest = "Round " +  String(sender.tag)
//        //view.roundName.text =
//    
//    }
    
        func addQuestion(){
            var view: VCmiQuizzesDetailAddQuestion = self.storyboard?.instantiateViewControllerWithIdentifier("VCmiQuizzesDetailAddQuestion") as! VCmiQuizzesDetailAddQuestion
            //Set the animation
            self.navigationController?.pushViewController(view, animated: true)
            //view.quizName.text = "Round " +  String(sender.tag)//Set the text
            view.title = self.title
            //view.roundName = "Round " +  String(sender.tag)
            
            view.roundNameTest = theSelectedName
            //view.roundName.text =
        
        }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var deleteButton = UITableViewRowAction(style: .Default, title: "Remove", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commitEditingStyle: .Delete,
                forRowAtIndexPath: indexPath
            )
            
            return
        })
        
        deleteButton.backgroundColor = UIColor.orangeColor()
        
        return [deleteButton]
    }
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            
           
                //miQuestions.removeObject(elements)
                //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                var ref = Firebase(url:"https://miquiz.firebaseio.com/Questions" )
            let sec = indexPath.section
            var count = 0
            for spaces in roundSec{
                if sec > spaces as! Int {count++}
            
            }
            //print("\(count)")
            
            //println("\(indexPath.row)")
                //var ref = Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes/\(name)/Round \(indexPath.section + 1)" )
                ref.observeSingleEventOfType(.Value, withBlock:{snapshot in
                
                
                    for rest in snapshot.children.allObjects as! [FDataSnapshot]{
                        
                        
                        var child = rest.children.allObjects
                        
                        var ID = ""
                        
                        for elements in child as! [FDataSnapshot]{
                            
                            if elements.key == "ID"
                            {
                                ID = elements.value as! String
                                
                            }
                            
                        }
                        for elements in child as! [FDataSnapshot]{
                            
                            if elements.key == "Question" {
                                if elements.value as! String == self.miQuestions[indexPath.row + count] as! String
                                {
                                    //var addToQuiz = Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes/\(self.quizName.text!)/Round 1" )
                                    //let post1 = ["ID": ID]
                                    //let post1Ref = addToQuiz.childByAutoId()
                                    //post1Ref.setValue(post1)
                                    
                                    //print("\(indexPath.section + 1)")
                                    var newRef = Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes/\(self.name)/Round \(indexPath.section + 1)" )
                                    //println(newRef)
                                    newRef.observeSingleEventOfType(.Value, withBlock:{snapshot in
                                        
                                        
                                        for all in snapshot.children.allObjects as! [FDataSnapshot]{
                                            
                                            var newChild = all.children.allObjects
                                            for parts in newChild as! [FDataSnapshot]{
                                                //println("\(ID)")
                                                //println("\(parts.value) but the ID is set to: \(ID)")
                                                if parts.key == "ID" && parts.value as! String == ID
                                                {
                                                    
                                                    var theRef = Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes/\(self.name)/Round \(indexPath.section + 1)/\(all.key)" )
                                                    let post1 = []
                                                    theRef.setValue(post1)
                                                    theRef.observeSingleEventOfType(.Value, withBlock:{snapshot in
                                                    var questionsInRound = snapshot.childrenCount
                                                    
                                                    if questionsInRound == 0{
                                                        
                                                        var refToAlter = Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes/\(self.name)")
                                                        for all in snapshot.children.allObjects as! [FDataSnapshot]{
                                                            let newName = "Test"
                                                            refToAlter.setValue(newName)
                                                        }
                                                    }
                                                
                                                    })
                                                    //var view: VCmiQuizzesDetail = self.storyboard?.instantiateViewControllerWithIdentifier("VCmiQuizzesDetail") as! VCmiQuizzesDetail
                                                    //tableView.reloadData()
                                                    //self.navigationController?.pushViewController(view, animated: true)
                                                }
                                                
                                            }
                                        
                                        }
                                    
                                    })
                                    
                                }
                            }
                        }
                        
                        
                       
                    }
                   
                })
                
                
        }
                
        
       
     }
    
    
   
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(true)
//            tableView.reloadData()
//       
//    }
    

}
class CustomHeaderCellTableViewCell: UITableViewCell {
    
    var activeRound = "Test"
    @IBOutlet var headerLabel: UILabel!
    @IBAction func touchArea(sender: AnyObject) {
        activeRound = headerLabel.text!
        theSelectedName = activeRound
        
    }
    
    
    
    
}
