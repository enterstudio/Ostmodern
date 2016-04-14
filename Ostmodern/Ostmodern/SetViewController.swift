//
//  ViewController.swift
//  Ostmodern
//
//  Created by Administrator on 30/03/2016.
//  Copyright © 2016 mahesh lad. All rights reserved.
//

import UIKit

class SetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
      
    var  setsArray : [Sets] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         tableView.registerNib(UINib(nibName: "SetsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        downloadRequestSets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Mark: - table delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        
        return  setsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SetsTableViewCell
        
        cell.title.text = setsArray[indexPath.row].title
        if  setsArray[indexPath.row].episode.count > 0 {
            cell.episodeCountLabel.text =  "\(setsArray[indexPath.row].episode.count)"
        } else {
            cell.episodeCountLabel.text = ""
        }

        cell.setsImage.image = UIImage(data:  setsArray[indexPath.row].data)
        return cell
        
    }
 
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
     
         if  setsArray[indexPath.row].episode.count > 0 {
            let vc  = storyboard!.instantiateViewControllerWithIdentifier("episodeVC") as! EpisodeViewController
            vc.episode =  setsArray[indexPath.row].episode
            vc.passedTitle =   setsArray[indexPath.row].title
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
   /**/
    
    //Mark: - load data
    
    func downloadRequestSets()
    {
       let url = NSURL(string: "http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000/api/sets/")
     
        
        let request = NSURLRequest(URL: url!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            // notice that I can omit the types of data, response and error
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            // parse the result as JSON, since that's what the API provides
            let post: NSDictionary
            do {
                post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
                
              //  print(post.description)
                if let arrays = post["objects"] as? NSArray {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        self.readSetRecords( arrays)
                       
                    }
                   
                }

            } catch  {
                print("error trying to convert data to JSON")
                return
            }
     
            
            
        });
        
        // do whatever you need with the task e.g. run
        task.resume()
    }

    func readSetRecords( arrays : NSArray) {
        for array in arrays {
            var titlePrivate = ""
            var idPrivate = ""
            var linkPrivate = ""
            var episodeArrayPrivate : [String] = []
          
            if let dict = array as? NSDictionary {
            
            if let uid = dict["uid"] as? String {
                idPrivate = uid
            }
            if let title = dict["title"] as? String {
                titlePrivate = title
            }
            
            
            if let itemArray = dict["items"] as? NSArray {
                if   itemArray.count > 0 {
                    episodeArrayPrivate = accumulateEpisodes(itemArray,  episodeArray : episodeArrayPrivate)
                   
                }
                
            }
            
        
            if  let  image_urls : [String] = dict["image_urls"]as?  [String] {
                
                if image_urls.count > 0 {
                    
                    self.getImageUrl((root_url + image_urls[0]), completion: { (result) in
                        
                        linkPrivate = result
                        self.addToSetsAndLoadTable( idPrivate, link: linkPrivate,  title: titlePrivate, episodeArray: episodeArrayPrivate)
                    })
                    
                } else {
                    //use defailt image
                    linkPrivate = default_image
                    self.addToSetsAndLoadTable(idPrivate , link: linkPrivate,  title: titlePrivate, episodeArray: episodeArrayPrivate)
                    
                }
                
            }
            
            }
            
        }

    }
    
    func accumulateEpisodes(itemArray: NSArray,  episodeArray : [String]) -> [String] {
        var mutable_episodeArray = episodeArray
        for  item in itemArray {
            
            if let itemDict = item as? NSDictionary {
                if let episode = itemDict["content_url"] as? String {
                    
                    if self.hasEpisode( episode ) {
                      mutable_episodeArray +=  [ root_url + episode]
                        
                    }
                }
            }
            
        }
        return mutable_episodeArray
    }
    
    func addToSetsAndLoadTable( id: String, link: String, title:String, episodeArray: [String] ) {
       
        let url = NSURL(string: link)
        let data = NSData(contentsOfURL: url!)
        
        let set = Sets(id: id, link: link,  data : data! ,title: title, episode: episodeArray )
        
        dispatch_async(dispatch_get_main_queue()) {
            self.setsArray.append(set)
            //  if you want to sort by title !
             // self.setsArray.sortInPlace({ "\( $0.title)" < "\( $1.title)" })
            self.tableView.reloadData()
        }

    }
    
    func getImageUrl(input: String, completion: (result: String) -> Void) {
        
        let url = NSURL(string: input)
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
                
                   if let url = post["url"] as? String {
                           completion(result: url)
                   } else {
                     completion(result: default_image)
                }
                
            } catch  {
                self.alerDialog("Error", message: "error trying to convert data to JSON")
                return
            }
            
        });
        
        // do whatever you need with the task e.g. run
        task.resume()
    }
    
   
    
    func hasEpisode( episode : String) -> Bool{
        return episode.substringToIndex(
            episode.startIndex.advancedBy(14))  ==  "/api/episodes/"
    }

 
}

public extension UIViewController
{
    
    func alerDialog( title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
}


