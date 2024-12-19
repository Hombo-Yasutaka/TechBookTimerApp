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
        configureSearchBar()

    }

    func configureNavigationBar() {
        let closeButton = UIBarButtonItem(title: "キャンセル",
                                          style: .plain,
                                          target: self,
                                          action: #selector(didTapCloseButton))
        navigationItem.leftBarButtonItem = closeButton // leftかrightかで左右を選択
        navigationItem.title = "本の登録"
    }

    func configureSearchBar() {
        searchBar.placeholder = "ISBNを入力してください"
    }

    @objc func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }

    func showAlert() {
        let alert = UIAlertController(title: "検索に失敗しました",
                                      message: "正しいISBNを入力してください。",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

extension RegistBookViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)

        if let word = searchBar.text {
            print("検索ワード: \(word)")
            let request = BookSearchRequest()
            request.searchBook(keyword: word) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print("response: \(response)")
                    case .failure(_):
                        self.showAlert()
                    }
                }
            }
        }
    }
}
