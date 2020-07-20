//
//  HomeViewController.swift
//  TestPryaniky
//
//  Created by Лилия Левина on 15.07.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate {
    
    let urlName = "https://pryaniky.com/static/json/sample.json"
    var dataArray = [Any]()
    
    var tableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SelectorTableViewCell.self, forCellReuseIdentifier: SelectorTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        getFromURL(urlName: urlName)
    }
    
    func configureObjects() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isUserInteractionEnabled = true
        self.view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func getFromURL(urlName: String) {
        if let url = URL(string: urlName) {
            let request = URLRequest(url: url as URL)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, eror) in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(DataView.self, from: data)
                        self.configureDataArray(resource:res)
                    } catch let error {
                        print(error)
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.configureObjects()
                })
            }
            task.resume()
        }
    }
    
    fileprivate func configureDataArray(resource:DataView) {
        for v in resource.view {
            for namedData in resource.data {
                if namedData.name == v {
                    switch v {
                    case .hz:
                        self.dataArray.append(Hz(data: namedData.data))
                    case .picture:
                        self.dataArray.append(Picture(data: namedData.data))
                    case .selector:
                        self.dataArray.append(SelectorData(data: namedData.data))
                    }
                }
            }
        }
    }
    
    fileprivate func showAlert(title: String?, text: String) {
         let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "ОК", style: .cancel))
         present(alertController, animated: true)
     }

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dataObj = dataArray[indexPath.row]
        switch dataObj {
        case is Hz:
             let dataObj = dataObj as! Hz
             cell.textLabel?.text = dataObj.text
        case is Picture:
            let dataObj = dataObj as! Picture
            cell.imageView?.imageFromServerURL(urlString: dataObj.url, PlaceHolderImage: UIImage(named: "placeHolder")!)
            cell.textLabel?.text = dataObj.text
        case is SelectorData:
            let dataObj = dataObj as! SelectorData
            var cell = tableView.dequeueReusableCell(withIdentifier: SelectorTableViewCell.reuseIdentifier, for: indexPath) as? SelectorTableViewCell
                if cell == nil {
                    cell = SelectorTableViewCell(style: .default, reuseIdentifier: SelectorTableViewCell.reuseIdentifier)
                }
            cell?.delegate = self
            cell?.configureSubViews(dataModel: dataObj)
            return cell!
        default:
             cell.textLabel?.text = String(indexPath.row)
        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert(title: "!", text: "Выбран объект \(type(of: dataArray[indexPath.row]))")
    }
}

extension HomeViewController: SelectorTableViewCellDelegate {
    func pickerDidSelect(item: Variant) {
        self.view.endEditing(true)
        showAlert(title: "!", text: "Выбран объект \(type(of: item)) id = \(item.id))")
    }
}


