//
//  ViewController.swift
//  Wiki Search
//
//  Created by praveen on 8/20/18.
//  Copyright © 2018 TubeRideShare. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    var searchActive: Bool = false
    var listWIKI:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mySearchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listWIKI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:WIKICell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WIKICell
        
        let data = self.listWIKI.object(at: indexPath.row) as? NSDictionary
        cell.ibTilteLbl.text = data?.object(forKey: "title") as? String
        let description = (data?.object(forKey:"terms") as? NSDictionary)?.object(forKey: "description") as? NSArray
        cell.ibDescriLbl.text = description?.object(at: 0) as? String
        
        if let imgURL = (data?.object(forKey:"thumbnail") as? NSDictionary)?.object(forKey: "source") as? String {
             cell.ibImageLbl.downloadImageFrom(link:imgURL, contentMode: UIViewContentMode.scaleAspectFit)
        }
        
        return cell
    }
    
    func get_data_from_url(urlString:String){
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
         
                return
            }
            print(data)

                do{
                    let JSONData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    
                    self.listWIKI = (JSONData.object(forKey: "query") as! NSMutableDictionary).object(forKey: "pages") as! NSMutableArray
                     DispatchQueue.main.async {
                        self.tableView.reloadData()
                     }
                    print(JSONData);
                }
                catch{
                    print("Error in trying JSONSerialization")
                }
        }
        task.resume()
    }
    
        
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if (searchBar.text == ""){
            searchActive = false
            self.listWIKI.removeAllObjects()
            self.tableView.reloadData()
            self.view.endEditing(true)
        }
        else {
            searchActive = true
            let searchString: String = (searchBar.text?.lowercased())!
            if (searchString != ""){
                loadAPIForSerchText(searchText:searchString)}
        }
    }
    
    func loadAPIForSerchText(searchText:String) {
        
        let String = "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=\(searchText)&gpslimit=20";
        get_data_from_url(urlString: String)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = ""
        self.listWIKI.removeAllObjects()
        self.tableView.reloadData()
        self.view.endEditing(true)
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}

