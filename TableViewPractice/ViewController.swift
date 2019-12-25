//
//  ViewController.swift
//  TableViewPractice
//
//  Created by INYEONGKIM on 2019/12/24.
//  Copyright © 2019 INYEONGKIM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // tableview
    // 1. data
    // 2. data num
    // 3. (opt) if row is clicked
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    var newsData :Array<Dictionary<String, Any>>?
    
    func getNews(){
        let task = URLSession.shared.dataTask(with: URL(string: "https://newsapi.org/v2/top-headlines?country=kr&apiKey=API_KEY_HERE"
        )!) { (data, responese, error) in
            if let dataJSON = data{
                // json parsing
                do{
                    // Dictionary<String, Any> = JSON
                    let json = try JSONSerialization.jsonObject(with: dataJSON, options: []) as! Dictionary<String, Any>
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    
                    self.newsData = articles
                    
                    DispatchQueue.main.async {
                        self.TableViewMain.reloadData()
                    }
                    
                    // value check
//                    for(idx, value) in articles.enumerated(){
//                        if let v = value as? Dictionary<String, Any>{
//                            print("\(v["title"])")
//                        }
//                    }
                }
                catch{}
            }
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // data num
        if let news = newsData{
            // 그냥 배열의 개수를 가져오는 방법
            return news.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // data
        // ver1 manual
//        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "TableCellType1")
//        cell.textLabel?.text = "\(indexPath.row)"

        // ver2
        // as?, as! = 부모 자식 친자확인 용도
//        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
//        cell.LabelText.text = "\(indexPath.row)"
        
        // ver3
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        
        let idx = indexPath.row
        if let news = newsData{
            let row = news[idx]
            if let v = row as? Dictionary<String, Any>{
                if let title = v["title"] as? String{
                    cell.LabelText.text = title
                }
            }
        }
        

        return cell
    }
    
    // ver1 : click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("CLICK!! \(indexPath.row)") // how to check
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "NewsDetailController") as! NewsDetailController
        
        // 값 setting
        if let news = newsData{
            let row = news[indexPath.row]
            if let r = row as? Dictionary<String, Any>{
                if let imageURL = r["urlToImage"] as? String{
                    controller.imageURL = imageURL
                }
                if let desc = r["description"] as? String{
                    controller.desc = desc
                }
            }
        }
        
        // 이동 (수동)
//        showDetailViewController(controller, sender: nil)
    }
    
    // ver2 : segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "NewsDetail" == id{
            // 값 setting
            if let controller = segue.destination as? NewsDetailController{
                if let news = newsData{
                    if let indexPath = TableViewMain.indexPathForSelectedRow{
                        let row = news[indexPath.row]
                        if let r = row as? Dictionary<String, Any>{
                            if let imageURL = r["urlToImage"] as? String{
                                controller.imageURL = imageURL
                            }
                            if let desc = r["description"] as? String{
                                controller.desc = desc
                            }
                        }
                    }
                }
            }
        }
        // 이동 (자동, 이미 storyboard에서 해뒀기 때문)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self == class 내의 function
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
        
        getNews()
    }
    
}

