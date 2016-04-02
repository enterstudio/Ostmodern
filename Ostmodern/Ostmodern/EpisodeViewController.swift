//
//  EpisodeViewController.swift
//  Ostmodern
//
//  Created by Administrator on 02/04/2016.
//  Copyright © 2016 mahesh lad. All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

     @IBOutlet weak var tableView: UITableView!
    var episode : [String] = []
    var episodeTitle : [String] = []
    var passedTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
            self.navigationItem.title  = passedTitle  + " Episodes"
        for epi in episode {
            download_request_Episode( epi)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        
        return  episodeTitle.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
       let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
     
        cell.textLabel?.text = episodeTitle[indexPath.row]
       
       return cell
        
    }
    
    func download_request_Episode( episodeUrl : String)
    {
        let url = NSURL(string: episodeUrl)
       
        
        let request = NSURLRequest(URL: url!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            // notice that I can omit the types of data, response and error
            guard let responseData = data else {
                self.alerDialog("Error", message: "Error: did not receive data")
                return
            }
            guard error == nil else {
            
                  self.alerDialog("Error", message: (error?.localizedDescription)!)
              
                return
            }
            // parse the result as JSON, since that's what the API provides
            let post: NSDictionary
            do {
                post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
                
                //  print(post.description)
                        if let title = post["title"] as? String {
                                //   print(title)
                               self.episodeTitle += [title]
                                dispatch_async(dispatch_get_main_queue()) {
                                  
                                self.tableView.reloadData()
                               }
                            }
                
                
            } catch  {
               
                 self.alerDialog("Error", message: "error trying to convert data to JSON")
                return
            }
            
            
            
        });
        
        // do whatever you need with the task e.g. run
        task.resume()
    }



}
