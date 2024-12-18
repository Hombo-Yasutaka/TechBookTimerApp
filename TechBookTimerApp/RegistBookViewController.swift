//
//  RegistBookViewController.swift
//  TechBookTimerApp
//
//  Created by 本坊康孝 on 2024/12/17.
//

import UIKit

class RegistBookViewController: UIViewController {

    @IBOutlet weak var cancellButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("本の登録画面です")
        searchBar.delegate = self

    }


    @IBAction func tappedCancellButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension RegistBookViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)

        if let word = searchBar.text {
            print("検索ワード: \(word)")
            let request = BookSearchRequest()
            request.searchBook(keyword: word, completion: { books in

            })
        }
    }
}
