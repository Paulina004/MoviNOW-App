

import UIKit

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath) //the difference between a URL and a string is that the URL checks that it's correctly formed
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Properties
    
    var movies = [[String:Any]]() //creation of an array of dictionaries
    
    
    
    //MARK: - When App Is Loaded
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                 
                    self.collectionView.reloadData()
                    
                    //This prints everything we fetched from the API.
                    print(self.movies)
             }
        }
        task.resume()

    }
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //TODO: Get the new view controller using segue.destination.
        //TODO: Pass the selected object to the new view controller.
        
        print("Loading up the details screen.")
        
        //Find the selected movie.
        let cell = sender as! UICollectionViewCell //the sender is the cell we clicked
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.row] //now we have found the selected cell
        
        //Pass the selected movie to the details view controller.
        let gridDetailsViewController = segue.destination as! MovieGridDetailsViewController
        gridDetailsViewController.movie = movie
        
        //This unhighlights the cell after you viewed its details and return to the main movies view controller.
        //collectionView.deselectRow(at: indexPath, animated: true)

    }
}
