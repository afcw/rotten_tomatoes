//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by Wanda Cheung on 9/23/14.
//  Copyright (c) 2014 Wanda Cheung. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var movieTableView: UITableView!
  
    var moviesArray: NSArray = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        movieTableView.delegate = self
        movieTableView.dataSource = self
      
        // Supposed to fix issue with separator inset in iOS8
        if (movieTableView.respondsToSelector(Selector("layoutMargins"))) {
          movieTableView.layoutMargins = UIEdgeInsetsZero;
        }
      
        movieTableView.backgroundColor = .blackColor()
        movieTableView.tintColor = .whiteColor()
      
        SVProgressHUD.show()
        loadMoviesArray()
    }
  
    override func viewDidAppear(animated: Bool) {
        movieTableView.addPullToRefreshWithActionHandler(loadMoviesArray)
        movieTableView.pullToRefreshView.activityIndicatorViewStyle = .Gray
    }
  
    func loadMoviesArray() {
        let request = NSMutableURLRequest(URL: getEndpointURL())
        request.timeoutInterval = NSTimeInterval(10)
      NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error: NSError!) in SVProgressHUD.dismiss()
          if error != nil {
              var errorMsg = error.localizedDescription
            CSNotificationView.showInViewController(self, style: CSNotificationViewStyleError, message: "\(errorMsg)")
          } else {
              var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
              self.moviesArray = object["movies"] as NSArray
              self.movieTableView.reloadData()
            
              if (self.movieTableView.pullToRefreshView != nil) {
                  self.movieTableView.pullToRefreshView.stopAnimating()
              }
          }
        })
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func getEndpointURL() -> NSURL {
          return RottenTomatoesApi.getEndpointURL(.BoxOffice)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return moviesArray.count
    }
  
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
          var cell = movieTableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
      
          var movie: Movie
      
          movie = Movie(dictionary: moviesArray[indexPath.row] as NSDictionary)
          cell.movieTitleLabel.text = movie.title
          cell.synopsisLabel.text = movie.synopsis
          cell.ratingLabel.text = movie.mpaaRating
      
          let request = NSURLRequest(URL: movie.thumbnailURL)
          let cachedImage = UIImageView.sharedImageCache().cachedImageForRequest(request)
          if (cachedImage != nil) {
          cell.posterView.image = cachedImage
          } else {
          // Fade in the image after it is loaded
              cell.posterView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) in
                cell.posterView.alpha = 0.0
                cell.posterView.image = image
                UIView.animateWithDuration(1.0, animations: {
                    cell.posterView.alpha = 1.0
                  })
                }, failure: nil)
          }
      
      if (cell.respondsToSelector(Selector("layoutMargins"))) {
          cell.layoutMargins = UIEdgeInsetsZero;
        }
          return cell
      
    }
 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "details" {
          let controller = segue.destinationViewController as DetailViewController
          let indexPath = movieTableView.indexPathForSelectedRow()!
        controller.movie = Movie(dictionary: moviesArray[indexPath.row] as NSDictionary)
      }
  
    }

}
