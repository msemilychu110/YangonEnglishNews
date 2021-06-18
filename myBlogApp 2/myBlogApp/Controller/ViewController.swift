//
//  ViewController.swift
//  myBlogApp
//
//  Created by Emily-Khine Chu on 10/22/18.
//  Copyright © 2018 Emily-Khine Chu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var model = ArticleModel()
    var articles = [Article]()
    let latestXRateStr = "https://forex.cbm.gov.mm/api/latest"
    @IBOutlet weak var euroLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var temp: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        model.delegate = self
        model.getArticles()
        getWeatherInfo()
        getCurrencyExchange()
        
        let refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                                        #selector(ViewController.handleRefresh(_:)),
                                     for: UIControl.Event.valueChanged)
            refreshControl.tintColor = UIColor.red
            
            return refreshControl
        }()
        self.tableView.addSubview(refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        model.getArticles()
        getWeatherInfo()
        getCurrencyExchange()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    func getCurrencyExchange() {
        let latestXRateURL = URL(string: latestXRateStr)
        guard let url = latestXRateURL else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                print("Got data")
                
                do {
                    if let dataConverted = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        print(dataConverted)
                        
                        if let rates = (dataConverted["rates"] as? [String: Any]) {
                            
                            let usd = rates["USD"]  ?? 0
                            print(usd)
                            let euro = rates["EUR"]  ?? 0
                            print(euro)
                            
                            DispatchQueue.main.async {
                                self.usdLabel.text = (usd as? String)
                                self.euroLabel.text =   (euro as? String)
                            }
                        }
                    }
                }
                catch {
                    print("converting failed")
                }
            }
            else {
                print("Error")
            }
        }
        task.resume()
    }
    
    func getWeatherInfo(){
        let apiKey = "e9350f613745c652c20536fca9ac44eb"
        let urlStr = "http://api.openweathermap.org/data/2.5/weather?q=Yangon&APPID=\(apiKey)"
        let url = URL(string: urlStr)
        guard let url = url else {return}
        let request = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { (data, res, error) in
            if error == nil && data != nil{
                print("Got Data")
                do{
                    if let dict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]{
                        
                        if let main = (dict["main"] as? [String:Any])
                        {
                            
                            let temp = main["temp"] as? Double ?? 0
                            DispatchQueue.main.async {
                                self.temp.text = String(temp - 273.15)
                            }
                        }
                        
                        if let wind = (dict["wind"] as? [String:Any]){
                            let speed = wind["speed"] as? Double ?? 0
                            DispatchQueue.main.async {
                                self.windLabel.text = String(speed)
                            }
                            
                        }
                    }
                }
                catch{
                    
                }
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: NewsTableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "cell1") as? NewsTableViewCell {
            cell = reuseCell
        }else {
            cell = NewsTableViewCell(style: .default, reuseIdentifier: "cell")
        }
        let article = articles[indexPath.row]
        cell.displayArticle(article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        if let link = URL(string: article.url ?? "") {
            UIApplication.shared.open(link)
        }
    }
}

extension ViewController: ArticleModelProtocol {
    func articlesRetrieved(_ articles: [Article]){
        self.articles = articles
        tableView.reloadData()
    }
}


