//
//  HomeVC.swift
//  SampleViperArch
//
//  Created by Shariq on 2023-10-12.
//

import UIKit
import SafariServices

protocol PresenterToViewHomeProtocol: AnyObject {
    func homeApiSuccess(data: [HomeModel])
    func homeApiError(errMsg: String)
}

class HomeView: UIViewController {

    @IBOutlet weak var table: UITableView!
    var data = [HomeModel]()
    var presentor: ViewToPresenterHomeProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.navigationController?.navigationBar.show()
        navigationItem.title = "Home"
        table.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        
        presentor?.interactor?.callApi()
    }

}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: "HomeCell") as? HomeCell else {return UITableViewCell()}
        cell.setupData(data: self.data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let safari = SFSafariViewController(url: URL(string: data[indexPath.row].web_pages.first ?? "")!)
        safari.modalPresentationStyle = .overFullScreen
        present(safari, animated: true, completion: nil)
    }
}

extension HomeView:PresenterToViewHomeProtocol{
    
    func homeApiSuccess(data: [HomeModel]) {
        SwiftLoader.hide()
        self.data = data
        table.reloadData()
    }
    
    func homeApiError(errMsg: String) {
        SwiftLoader.hide()
        let alert = UIAlertController(title: "Alert", message: errMsg.debugDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
