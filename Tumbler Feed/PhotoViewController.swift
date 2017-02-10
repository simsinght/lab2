//
//  UserViewController.swift
//  Tumbler Feed
//
//  Created by Rajit Dang on 2/2/17.
//  Copyright © 2017 Rajit Dang. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var posts: [NSDictionary] = []
    
    var refreshControl: UIRefreshControl?
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource =  self
        tableView.rowHeight = 240
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl!, at: 0)


        loadDataFromNetwork(reload: false, loadMore: false)
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    
    
    /* function for database call */
    func loadDataFromNetwork( reload: Bool, loadMore: Bool) {

        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(posts.count)")
        
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
    
        
        if (reload)  {
            
        } else {
            // Display HUD right before the request is made
            // MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.posts += responseFieldDictionary["posts"] as! [NSDictionary]
                        self.tableView.reloadData()
                        
                        if(loadMore){
                            self.isMoreDataLoading = false
                        }
                        
                        if (reload) {
                            // Tell the refreshControl to stop spinning
                            self.refreshControl?.endRefreshing()
                        }
                        else {
                            // Hide HUD once the network request comes back
                            // MBProgressHUD.hide(for: self.view, animated: true)
                        }
                    }
                    
                }
        });
        task.resume()
    }

    
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadDataFromNetwork(reload: true, loadMore: false)
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
                print("loading more")
                loadDataFromNetwork(reload: false, loadMore: true)
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (posts.count)
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoViewCell
        
        // Configure YourCustomCell using the outlets that you've defined.
        let post = posts[indexPath.row]
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageUrl = URL(string: imageUrlString!) {
                // URL(string: imageUrlString!) is NOT nil, go ahead and unwrap it and assign it to imageUrl and run the code in the curly braces
                cell.photoView.setImageWith(imageUrl)
            } else {
                // URL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
            }
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
        }
    
        return cell

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using 
        let vc = segue.destination as! PhotoDetailsViewController
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        
        let post = posts[(indexPath?.row)!]
        vc.post = post;
        
        tableView.deselectRow(at: indexPath!, animated: true)
        
        
        // Pass the selected object to the new view controller.
    }

}
