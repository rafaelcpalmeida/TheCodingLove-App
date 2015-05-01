//
//  MainTableViewController.swift
//  TheCodingLove
//
//  Created by Rafael Almeida on 25/04/15.
//  Copyright (c) 2015 Rafael Almeida. All rights reserved.
//

import UIKit


class MainTableViewController: UITableViewController {

    var titles = [String] ()
    var ready = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.getTopPostsWithSucess{ (data) -> Void in
            // Get #1 app name using SwiftyJSON
            let json = JSON(data: data)
            /*if let appName = json["response"]["posts"][0]["title"].string {
                println("SwiftyJSON: \(appName)")
                
            }*/
            
            for (key: String, subJson: JSON) in json["response"]["posts"] {
                //Do something you want
                //println(subJson["title"])
                //println(subJson["body"])
                var _title = subJson["title"].stringValue
                var _body = subJson["body"].stringValue
                var info = self.getInfo(subJson["body"].stringValue)
                self.titles.append("\(_title);\(info.image);\(info.author)")
            }
            
            if(self.titles.count == 20)
            {
                self.ready = true
                self.tableView.reloadData()
            }
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 20
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        if let postCell = cell as? PostTableViewCell
        {
            /*DataManager.getTopPostsWithSucess{ (data) -> Void in
                let json = JSON(data: data)
                    postCell.postTitleLabel.text = json["response"]["posts"][indexPath.row]["title"].string
            }*/
            if(ready)
            {
                var _data = titles[indexPath.row].componentsSeparatedByString(";")
                var _url = NSURL(string: "http://tclhost.com/sgCaFnQ.gif")
                //var _url = NSURL(string: _data[1])
                var _img = NSData(contentsOfURL: _url!)
                postCell.postTitleLabel.text = _data[0]
                postCell.postImage.image = UIImage(data: _img!)
                postCell.postAuthorLabel.text = _data[2]
            }
        }
        // Configure the cell...

        return cell
    }
    
    private func getInfo(str: String) -> (image: String, author: String)
    {
        var image = ""

        //author = str.replace("\\n", template: "")
        
        return (image,str.replace("<(?:\"[^\"]*\"['\"]*|'[^']*'['\"]*|[^'\">])+>", template: "").replace("\\n", template: ""))
    }

}
