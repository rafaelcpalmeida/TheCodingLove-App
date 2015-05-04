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
            let json = JSON(data: data)
            
            for (key: String, subJson: JSON) in json["response"]["posts"] {
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
            if(ready)
            {
                var _data = titles[indexPath.row].componentsSeparatedByString(";")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                    //... Background
                    var _url = NSURL(string: _data[1].stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
                    var imageData = NSData(contentsOfURL: _url!)
                    dispatch_async(dispatch_get_main_queue())
                    {
                        //... Novamente na main Queue
                        postCell.postImage.image = UIImage.animatedImageWithData(imageData!)
                    }
                }
                postCell.postTitleLabel.text = _data[0]
                postCell.postAuthorLabel.text = _data[2]
            }
        }
        // Configure the cell...

        return cell
    }
    
    private func getInfo(str: String) -> (image: [String], author: String)
    {
        var _image: String = str
        var _author: String = str
        return (_image.matchesForRegexInText("(http|ftp|https):\\/\\/([\\w\\-_]+(?:(?:\\.[\\w\\-_]+)+))([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?") as [String],_author.replace("<(?:\"[^\"]*\"['\"]*|'[^']*'['\"]*|[^'\">])+>", template: "").replace("\\n", template: ""))
    }

}
