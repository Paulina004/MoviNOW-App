//
//  MovieDetailsViewController.swift
//  NewMoviNOW
//
//  Created by Paulina DeVito on 9/8/22.
//


// Remember that this is the class that is associated with the movie details view controller. We had to manually associate that view controller with this class using the inspector panel on the right side of Xcode.
// Also, remember that this has to be a CocoaTouch file, UIViewController.

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    
    //MARK: - Properties
    var movie: [String:Any]!
    
    
    //MARK: - When App Is Loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(movie["title"])
        
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit() //adjusts label
        
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit() //adjusts label
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath) //the difference between a URL and a string is that the URL checks that it's correctly formed
        
        posterView.af.setImage(withURL: posterUrl!)
        
        
        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath) //the difference between a URL and a string is that the URL checks that it's correctly formed
        
        backdropView.af.setImage(withURL: backdropUrl!)
        
    }
}
