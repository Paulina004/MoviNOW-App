//
//  ViewController.swift
//  MoviNOW
//
//  Created by Paulina DeVito on 8/24/22.
//

import UIKit
import AlamofireImage

//In this class line, we have to add "UITableViewDataSource" and "UITableViewDelegate" for our Table View for the scrolling movies list.
//Click "Fix" on the error to add protocol stubs.
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //MARK: - Properties
    
    var movies = [[String:Any]]() //creation of an array of dictionaries
    
    
    
    //MARK: - When App Is Loaded
    
    //This function gets called when the app is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This is part of the table view process.
        tableView.dataSource = self
        tableView.delegate = self
        
        //This is the first thing to pop up in the output terminal when the app is loaded.
        print("Hello")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             //This will run when the network request returns.
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 
                    // What the code line below means:
                    // -> This is how we access a certain key in the dictionary.
                    // -> Also, we use casting (with the as! command).
                    self.movies = dataDictionary["results"] as! [[String:Any]]
                 
                    //After we get the movies from the API, we have to reload the tableView to have the updated info.
                    //If we don't do this, our table view will appear empty. This is because the movies have not been populated yet since the movies weren't fetches from the API and stored yet.
                    self.tableView.reloadData()
                 
                    //This prints everything we fetched from the API.
                    print(dataDictionary)
             }
        }
        task.resume()

    }
    
    
    //MARK: - Table View Cell Count
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    //MARK: - Table View Cell Creation
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //If a cell is off screen, you can recycle that cell's memory with this line. (Think about it this way: if you have thousands of cells, that's going to take a lot of memory--we don't want that!)
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row] //accesses a movie
        let title = movie["title"] as! String //fetches the title of the movie from the API (and we also cast)
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath) //the difference between a URL and a string is that the URL checks that it's correctly formed
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    
    
    //MARK: - Navigation
    
    //In a storboard-based application, you will often want to do a little preparation before navigation. That's what this function below is for.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //TODO: Get the new view controller using segue.destination.
        //TODO: Pass the selected object to the new view controller.
        
        print("Loading up the details screen.")
        
        //Find the selected movie.
        let cell = sender as! UITableViewCell //the sender is the cell we clicked
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row] //now we have found the selected cell
        
        //Pass the selected movie to the details view controller.
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        //This unhighlights the cell after you viewed its details and return to the main movies view controller.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
