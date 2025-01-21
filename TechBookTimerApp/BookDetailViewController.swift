//
//  BookDetailViewController.swift
//  TechBookTimerApp
//
//  Created by 本坊康孝 on 2025/01/14.
//

import UIKit
import RealmSwift

class BookDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var noImageLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    var bookDataModel = BookDataModel()
    var sectionDataList: [SectionDataModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureNavigationBar()
        configureBookData()
        configureAddButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSectionData()
        configureTableView()
        tableView.reloadData()
    }

    @IBAction func tappedAddButton(_ sender: UIButton) {
        navigateToRegistSectionViewController()
    }

    func configureNavigationBar() {
        let closeButton = UIBarButtonItem(title: "戻る",
                                          style: .plain,
                                          target: self,
                                          action: #selector(didTapCloseButton))
        navigationItem.leftBarButtonItem = closeButton // leftかrightかで左右を選択
    }

    func configureBookData() {
        self.bookNameLabel.text = bookDataModel.title
        if let url = URL(string: bookDataModel.imageUrl) {
            self.downloadImage(from: url)
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
        }
    }

    func configureAddButton() {
        addButton.layer.cornerRadius = addButton.bounds.width / 2
    }

    @objc func didTapCloseButton() {
        navigationController?.popViewController(animated: true)
    }

    func configureBookData(with book: BookDataModel) {
        self.bookDataModel = book
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

    func navigateToRegistSectionViewController() {
        let nextVC = RegistSectionViewController(nibName: "RegistSectionViewController", bundle: nil)
        nextVC.configureBookData(with: self.bookDataModel)
        let navi = UINavigationController(rootViewController: nextVC)
        navi.modalPresentationStyle = .fullScreen
        navigationController?.present(navi, animated: true)
    }

    func setSectionData() {
        let realm = try! Realm()

        // 渡されたBookオブジェクトに関連するSectionデータを取得
        let result = realm.objects(SectionDataModel.self).filter("ANY parentBook == %@", bookDataModel)
        sectionDataList = Array(result)

    }

    func configureTableView() {
        tableView.dataSource = self
//        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .lightGray
        tableView.separatorStyle = .singleLine
        if #available(iOS 15.0, *) {
            tableView.fillerRowHeight = 50
        }

        let messageLabel = UILabel()
        messageLabel.text = "+ボタンから章の登録を行なってください"
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 15)
        messageLabel.sizeToFit()
        if sectionDataList.isEmpty {
            tableView.backgroundView = messageLabel
        } else {
            tableView.backgroundView = nil
        }
    }
}

extension BookDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        // indexPath.row→UITableViewに表示されるCellの(0から始まる)通し番号が順番に渡される
        let sectionDataModel: SectionDataModel = sectionDataList[indexPath.row]
        cell.textLabel?.text = sectionDataModel.sectionName
        return cell
    }
}
