//
//  RegistBookViewController.swift
//  TechBookTimerApp
//
//  Created by 本坊康孝 on 2024/12/17.
//

import UIKit

class RegistBookViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("本の登録画面です")
        searchBar.delegate = self

        configureNavigationBar()

    }

    private func configureNavigationBar() {
        let closeButton = UIBarButtonItem(title: "キャンセル",
                                          style: .plain,
                                          target: self,
                                          action: #selector(didTapCloseButton))
        navigationItem.leftBarButtonItem = closeButton // leftかrightかで左右を選択
        navigationItem.title = "本の登録"
    }

    @objc func didTapCloseButton() {
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
