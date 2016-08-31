//
//  StudentTableViewController.swift
//  PutAPI
//
//  Created by Patrick Pahl on 8/31/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    var students: [Student] = [] {
        didSet{
            dispatch_async(dispatch_get_main_queue()) { 
                self.tableView.reloadData()
            }
        }
    }
    //As soon as the student arry is updated, the table will be reloaded too!!
    
    private func fetchStudents(){
        
        StudentController.fetchStudents { (students) in
            self.students = students
            //fetch students, add to array
        }
    }
    
    
    //MARK: - Outlets
    @IBOutlet weak var studentNameTextField: UITextField!
    
    
    //MARK: - Actions
    @IBAction func addButtonTapped(sender: AnyObject) {
        
        guard let name = studentNameTextField.text where name.characters.count > 0 else {return}
        
        StudentController.sendStudent(name) { (success) -> Void in
            
            if success == true {
                dispatch_async(dispatch_get_main_queue(), { 
                    
                    self.studentNameTextField.text = ""
                    
                    self.studentNameTextField.resignFirstResponder()
                    self.fetchStudents()
                    //Need to fetch students again after submitting another name to the array
                    //Once fetched, table auto reloaded by our didSet
                })
            }
        }
    }
    
    
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        fetchStudents()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath)
        
        let student = students[indexPath.row]
        
        cell.textLabel?.text = student.name
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
