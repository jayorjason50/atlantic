//
//  VCmiQuizzesDetailAddQuestion.swift
//  miQuiz
//
//  Created by Jason Spence on 27/07/2015.
//  Copyright (c) 2015 Jason Spence. All rights reserved.
//

import UIKit
import Darwin
class VCmiQuizzesDetailAddQuestion:UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var myPicker: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var quizName: UILabel!
    
    @IBAction func closeWindow(sender: AnyObject) {
        var view: VCmiQuizzesDetail = self.storyboard?.instantiateViewControllerWithIdentifier("VCmiQuizzesDetail") as! VCmiQuizzesDetail
        //Set the animation
        self.navigationController?.pushViewController(view, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    var data: NSMutableArray = NSMutableArray()
    var IDArray: NSMutableArray = NSMutableArray()
    
    let pickerData = ["Sport","Music","Geography","General Knowledge","History"]
    var search : [String] = []
//    var data = ["What is the capital city of England?","What is the capital city of Spain?","What is the capital city of Russia?","What is the capital city of Austria?","Why did Roselin Franklin (pre discovered DNA helix) win no Nobel prize?","A mountain is the symbol of which film company?","The French call it creme anglaise what do we call it?","What is French for hello?","How old is the Queen of Denmark?"]
    
    
    @IBOutlet weak var addQuestion: UIButton!
   
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        
        
        textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        addQuestion.addTarget(self, action: "addQuestion:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        doneButton.titleLabel!.font = UIFont(name: "Arial", size: 15)
        
        doneButton.addTarget(self, action: "submit:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var snapshot: FDataSnapshot = FDataSnapshot()
        var ref = Firebase(url:"https://miquiz.firebaseio.com/Questions")
        ref.observeSingleEventOfType(.Value, withBlock:{snapshot in
            for rest in snapshot.children.allObjects as! [FDataSnapshot]{
                
                
                var child = rest.children.allObjects
                
                for questions in child as! [FDataSnapshot]{
                    
                    if questions.key == "Question"{
                        var question = questions.value as! String
                        self.data.addObject(question)
                    }
                    
                    
                    
                }
                
            }
        })
        
        
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let (MiQuizTitle: AnyObject) = search[indexPath.row]
        cell.textLabel?.text = MiQuizTitle as? String
        
        cell.textLabel
        return cell
    }
    
    
    
    func textFieldDidChange(textField: UITextField) {
        tableView.hidden = false
        if answerField.hidden == true{
        
        if textField.text != ""{
            
            
            
            var stringText = textField.text.lowercaseString
    
            search.removeAll() //Empty the search array on each key press
            self.tableView.reloadData()
            
            for elements in data{
                
                var searchWord = elements as! String
             
                if searchWord.lowercaseString.rangeOfString(stringText) != nil{
                    
                    search.append(searchWord)
                    
                    
                }
               
                
                
            }
            if search.count == 0{
                
                tableView.hidden = true
                
            }
            else{
                
                tableView.hidden = false
                
            }
            
            self.tableView.reloadData()
            
        }
        else{
            
            
            answerField.hidden = true
            myPicker.hidden = true
            doneButton.hidden = true
            tableView.hidden = true
            
            
            
            }
        
        }
        else{
        
            if textField.text == ""{
                
                answerField.hidden = true
                myPicker.hidden = true
                doneButton.hidden = true
                tableView.hidden = false

            }
            else{
                tableView.hidden = true
            }
        
        
        
        
        
        }
        
        if textField.text != ""{
        
                addQuestion.hidden = false
        
        
        }
        else if textField.text == ""{
            
            addQuestion.hidden = true
        }
        
    }
    
    
    func submit(button:UIButton) {
        
        var questionToAdd = textField.text
        var answerToAdd = answerField.text
        var categoryToAdd: AnyObject = pickerData[myPicker.selectedRowInComponent(0)]
        
        
        
        var testRef = Firebase(url:"https://miquiz.firebaseio.com/Questions")

        testRef.observeSingleEventOfType(.Value, withBlock:{snapshot in
            
            var count = 1
            for rest in snapshot.children.allObjects as! [FDataSnapshot]{
                
                
                var child = rest.children.allObjects
                
                
                for elements in child as! [FDataSnapshot]{
                
                    if elements.key == "ID"{
                        var ID = elements.value as! String
                        count++
                    }
                }
                
            }
            

            var ref = Firebase(url:"https://miquiz.firebaseio.com/Questions/ID" + String(count) )
            var new = ["Question": questionToAdd, "Answer": answerToAdd, "Category": categoryToAdd, "ID":"ID" + String(count)]
            ref.setValue(new)
            
            var addToQuiz = Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes/\(self.quizName.text!)/Round 1" )
            let post1 = ["ID": "ID" + String(count)]
            let post1Ref = addToQuiz.childByAutoId()
            post1Ref.setValue(post1)
            
            
            
            
            
            
        })

        

        
      
        
        textField.text = ""
        answerField.text = ""
        
        answerField.hidden = true
        doneButton.hidden = true
        myPicker.hidden = true
        
        
        
        
        
        
        
      

        
        
        
    }

    
    
    
    
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int)-> String? {
        
        
        return "Suggestions"
    }
    
    
    
    func addQuestion(button:UIButton){
        
        
        answerField.hidden = false
        myPicker.hidden = false
        doneButton.hidden = false
        tableView.hidden = true
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        return(false)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView
    {
        var pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = pickerData[row]
        pickerLabel.font = UIFont(name: "Arial", size: 15) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var theRef = Firebase(url:"https://miquiz.firebaseio.com/Questions")
    
        theRef.observeSingleEventOfType(.Value, withBlock:{snapshot in
    
    
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
                                if elements.value as! String == self.search[indexPath.row]
                                {
                                    var addToQuiz = Firebase(url:"https://miquiz.firebaseio.com/MyQuizzes/\(self.quizName.text!)/Round 1" )
                                    let post1 = ["ID": ID]
                                    let post1Ref = addToQuiz.childByAutoId()
                                    post1Ref.setValue(post1)
                                    
                                    
    
                                }
                            }
                        }
    
            }
    
    
    
        })
        
        textField.text = ""

        tableView.hidden = true
        

    }
}

