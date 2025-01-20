//
//  RegistBookViewController.swift
//  TechBookTimerApp
//
//  Created by 本坊康孝 on 2024/12/17.
//

import UIKit
import RealmSwift

class RegistBookViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var noImageLabel: UILabel!

    var bookData = BookDataModel()
    var okFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        print("本の登録画面です")
        searchBar.delegate = self

        configureNavigationBar()
        configureSearchBar()
        configureBookNameLabel()

    }

    func configureNavigationBar() {
        let closeButton = UIBarButtonItem(title: "キャンセル",
                                          style: .plain,
                                          target: self,
                                          action: #selector(didTapCloseButton))
        navigationItem.leftBarButtonItem = closeButton // leftかrightかで左右を選択
        let registButton = UIBarButtonItem(title: "登録",
                                           style: .plain,
                                           target: self,
                                           action: #selector(didTapRegistButton))
        navigationItem.rightBarButtonItem = registButton
        navigationItem.title = "本の登録"
    }

    func configureSearchBar() {
        searchBar.placeholder = "ISBNを入力してください"
    }

    func configureBookNameLabel() {
        bookNameLabel.numberOfLines = 0
    }

    @objc func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc func didTapRegistButton() {
        if okFlag {
            saveData()
            dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "登録に失敗しました", message: "ISBNによる検索を行ってください")
        }

    }

    func downloadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to download image: \(error?.localizedDescription ?? "No error description")")
                return
            }
            DispatchQueue.main.async {
                self.bookImageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    func saveData() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(bookData)
        }
        print("bookData: \(bookData)")
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
                        print("response: \(response.summary.title!)")
                        self.bookNameLabel.text = response.summary.title
                        self.bookData.title = response.summary.title!
                        self.okFlag = true
                        if let imageString = response.summary.cover, let url = URL(string: imageString) {
                            self.bookData.imageUrl = imageString
                            self.downloadImage(from: url)
                            self.noImageLabel.isHidden = true
                            self.bookImageView.backgroundColor = .white
                        } else {
                            let label = UILabel()
                            label.text = "No Image"
                            label.textAlignment = .center
                            label.textColor = .gray
                            label.font = .systemFont(ofSize: 14)
                            label.translatesAutoresizingMaskIntoConstraints = false

                            // ImageViewに追加
                            self.bookImageView.addSubview(label)
                            self.bookImageView.backgroundColor = .systemGray6

                            // 制約を設定
                            NSLayoutConstraint.activate([
                                label.centerXAnchor.constraint(equalTo: self.bookImageView.centerXAnchor),
                                label.centerYAnchor.constraint(equalTo: self.bookImageView.centerYAnchor)
                            ])

                            self.noImageLabel = label
                            self.bookImageView.image = nil
                        }
                    case .failure(_):
                        self.showAlert(title: "検索に失敗しました",
                                       message: "正しいISBNを入力してください")
                    }
                }
            }
        }
    }
}
