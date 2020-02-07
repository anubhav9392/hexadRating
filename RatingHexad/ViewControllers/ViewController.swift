//
//  ViewController.swift
//  Hexad Rating
//
//  Created by Anubhav Chandra on 6/2/20.
//  Copyright © 2020 Anubhav Chandra. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MovielistDelegate,RatePopupDelegate {
    
    
    @IBOutlet var navBar: UINavigationBar!
    
    @IBOutlet var screenLabel: UILabel!
    @IBOutlet weak var randomBtn: UIButton!
    @IBOutlet weak var moviesTable: UITableView!
    var http:MyHttp!
    var movies:[Movie]?
    var queue:DispatchQueue!
    var tmpdata : [Movie]!
    
    var randomBtnClicked:Bool = false
    var screenValue : Int!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addSlideMenuButtonMyMesaage()
        // Do any additional setup after loading the view.
       addSlideMenuButtonMyMesaage()
        
        http = MyHttp()
        initializeData(value: defaults.string(forKey: "Screen") ?? "1")
        moviesTable.delaysContentTouches = false
        
        
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    func addSlideMenuButtonMyMesaage(){
        
        self.navigationItem.hidesBackButton = true
        let image = UIImage(named: "iconarrow")?.withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = button
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    

    // creates a table view
    func initializeData(value : String){
        do{
            if(value == "1"){
                screenLabel.text = "Movies Rating"
                 tmpdata = try http.fetchMovies()
            }else if(value == "2"){
                screenLabel.text = "Books Rating"
                 tmpdata = try http.fetchBooks()
            }else if(value == "3"){
                screenLabel.text = "Foods Rating"
                 tmpdata = try http.fetchFoods()
            }else{
                screenLabel.text = "Games Rating"
                 tmpdata = try http.fetchGames()
            }
            order(data: tmpdata)
            moviesTable.reloadData()
            
        } catch MyHttpError.InvalidJson{
            print("Invalid Json")
        }catch{
            print("Other error")
        }
    }
    
    
    //on rate button clicked
    func onClick(index: Int) {
        let ratecontroller = self.storyboard?.instantiateViewController(withIdentifier: "ratepopup") as! RatePopupController
        ratecontroller.index = index
        ratecontroller.ratingValue = movies![index].rating
        ratecontroller.delegate = self
        self.present(ratecontroller, animated: true, completion: nil)
    }
    
    // on random rating button clicked
    @IBAction func onRandomize(_ sender: Any) {
        if(randomBtnClicked){
            randomBtn.setTitleColor(.blue, for: .normal)
            randomBtnClicked = false
        }else{
            randomBtn.setTitleColor(.red, for: .normal)
            randomBtnClicked = true
            startRatingRandomly()
        }
        
    }
    
    // function to rate randomly called by button
    func startRatingRandomly(){
        showAlert(title: "Alert!", message: "Rating is started randomly at random time")
        queue = DispatchQueue(label: "work-queue")
        queue.async {
            while(self.randomBtnClicked){
                let randomIndex = Int.random(in: 0..<self.movies!.count)
                let randomRating = Int.random(in: 1...10)
                let randomTime = Int.random(in: 2...5)
                self.movies![randomIndex].rating = randomRating
                
                
                DispatchQueue.main.async {
                    self.order(data: self.movies!)
                }
                sleep(UInt32(randomTime)) //sleep for 2 seconds
            }
        }
    }
    
    // alert dialog function
    func showAlert(title: String, message: String){
        let alert = DialogBuilder(title: title, message: message).getAlert()
        self.present(alert, animated: true, completion: nil)
    }
    
    // callback called by dialog box
    func onRated(index: Int, rating: Int) {
        movies![index].rating = rating
        order(data: movies!)
        showAlert(title: "Success", message: "You have successfully rated the movie!")
    }
    
    
    // sorting function
    func order(data: [Movie]){
        var ratings =  [Int : Int]()
        for (index,x) in data.enumerated(){
            ratings[index] = x.rating
        }
        let sortedKeys = Array(ratings.keys).sorted(by: {(a:Int,b:Int) in
            return ratings[a]! > ratings[b]!
        })
        
        var sortedArray = [Movie]()
        for i in sortedKeys{
            sortedArray.append(data[i])
        }
        movies = sortedArray
        moviesTable.delegate = self
        moviesTable.dataSource = self
        moviesTable.reloadData()
    }
    
 

}



extension ViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovielistCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "movielistcell", for: indexPath) as! MovielistCell
        
        cell.delegate = self
        cell.setData(index:indexPath.row, data: movies?[indexPath.row] ?? Movie())
        return cell
    }
    
    
}

