//
//  DetailViewController.swift
//  Task Track
//
//  Created by JIANAN WEN on 12/15/17.
//  Copyright © 2017 JIANAN WEN. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    var needDate = ""

    
    var dateTaskArr : [Task] = [Task]()
   
    @IBOutlet var taskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadDateFromFirebase()
        
        
        taskTableView.dataSource = self
        taskTableView.delegate = self
        
        //set this page title
        self.title = formatdate(inputdate: needDate)
        // Do any additional setup after loading the view.
        
        
        taskTableView.register(UINib(nibName: "MessageCell", bundle : nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        
        taskTableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateTaskArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for : indexPath) as! CustomMessageCell
        
        cell.messageBody.text = dateTaskArr[indexPath.row].taskText
        
        if dateTaskArr[indexPath.row].finished {
            cell.avatarImageView.image = UIImage(named: "correct")
        }else{
            cell.avatarImageView.image = UIImage(named: "error")
        }

        return cell
    }
    
    func loadDateFromFirebase(){
        
        let userid = Auth.auth().currentUser?.uid
        
        let mydb = Database.database().reference().child(userid!).child(needDate)
        
        //get all data
        mydb.observe(.value) { snapshot in
            
            
            if snapshot.childrenCount > 0{
                
                
                for child in snapshot.children.allObjects as! [DataSnapshot] {

                    let taskobject = child.value as! [String : String]
                    
                    
                    let taskinfo = taskobject["taskInfo"]
                    let taskid = taskobject["id"]
                    let taskstate = taskobject["state"]
                    
                    let newTask = Task(id : Int(taskid!)!, finished : Bool(taskstate!)!, taskText : taskinfo!)
                    
                    
                    self.dateTaskArr.append(newTask)

                }
                self.taskTableView.reloadData()
            }
            
            
        }
        
        
    }
    
    func configureTableView(){
        taskTableView.rowHeight = UITableViewAutomaticDimension
        taskTableView.estimatedRowHeight = 240.0
        
    }
    
    func formatdate(inputdate : String) -> String{
        let dateString = inputdate // change to your date format
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let date = dateFormatter.date(from: dateString)
        
        
        let datefor1 = DateFormatter()
        datefor1.dateFormat = "MMM d yyyy"
        
        let date1 = datefor1.string(from: date!)
        
        return date1
    }
    
    



}
