//
//  VCmiQuizzesDetail.swift
//  miQuiz
//
//  Created by Jason Spence on 27/07/2015.
//  Copyright (c) 2015 Jason Spence. All rights reserved.
//

import UIKit

class VCmiQuizzesDetail: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var addQuestion: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var miQuestions: NSMutableArray = NSMutableArray()
    //var miQuizzes: NSMutableArray = NSMutableArray()
    var miRounds: NSMutableArray = NSMutableArray()
    var roundSec: NSMutableArray = NSMutableArray()
    var arrayInc = 0
    var quiz = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         name = self.title!
        addQuestion.addTarget(self, action: "addQuestion:", forControlEvents: UIControlEvents.TouchUpInside)

        
        
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
                                    var roundString = round as String
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var num = 1
        
        for elements in miRounds{
            
            num = elements as! Int //Update to get the number of rounds
            
        }
        
        
        
        
        
        return num
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int)-> String? {
        
        
        return "Round " + String(section + 1)//Get section and and 1 to get round number
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
        cell.imageView?.image = myImage
        
        
        
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Values to index into the array holding the data
        let row = indexPath.row
        let section = indexPath.section
        
        var count = 0
        var theCounter = 0
        for elements in roundSec{
            
            
            
            
            if elements as! Int == section{
                
                
                if count == row{
                    
                    var number = count + theCounter
                    quiz =  (miQuestions[count + theCounter] as! String) //Get string representation of the cells text
                    
                    //Make a reference to the VCQuestionEdit (It's Identifier is set via storyboard -> ID card icon -> Identifier
                    //var view: VCmiQuizzesDetailAddQuestion = self.storyboard?.instantiateViewControllerWithIdentifier("VCmiQuizzesDetailAddQuestion") as! VCmiQuizzesDetailAddQuestion
                    //Set the animation
                    //self.navigationController?.pushViewController(view, animated: true)
                    //view.title = miQuestions[count + theCounter] as? String //Set the text
                    
                    
                }
                count++
                
                
            }
            else{
                theCounter++
            }
            
        }
        
        
        
        
        
    }
    
    func addQuestion(sender:UIButton){
    
        var view: VCmiQuizzesDetailAddQuestion = self.storyboard?.instantiateViewControllerWithIdentifier("VCmiQuizzesDetailAddQuestion") as! VCmiQuizzesDetailAddQuestion
        //Set the animation
        self.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        presentViewController(view, animated: true, completion: nil)
        view.quizName.text = self.title //Set the text
        
    
    }
    

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
           
                //miQuestions.removeObject(elements)
                //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                var ref = Firebase(url:"https://miquiz.firebaseio.com/Questions" )
            
            
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
                                if elements.value as! String == self.miQuestions[indexPath.row] as! String
                                {
                                    //var addToQuiz = Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes/\(self.quizName.text!)/Round 1" )
                                    //let post1 = ["ID": ID]
                                    //let post1Ref = addToQuiz.childByAutoId()
                                    //post1Ref.setValue(post1)
                                    
                                    
                                    var newRef = Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes/\(self.name)/Round \(indexPath.section + 1)" )
                                    
                                    newRef.observeSingleEventOfType(.Value, withBlock:{snapshot in
                                        
                                        
                                        for all in snapshot.children.allObjects as! [FDataSnapshot]{
                                            
                                            var newChild = all.children.allObjects
                                            for parts in newChild as! [FDataSnapshot]{
                                                
                                                if parts.key == "ID" && parts.value as! String == ID
                                                {
                                                    
                                                    var theRef = Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes/\(self.name)/Round \(indexPath.section + 1)/\(all.key)" )
                                                    let post1 = []
                                                    theRef.setValue(post1)
                                                    
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
                    
       tableView.reloadData()
     }


}
