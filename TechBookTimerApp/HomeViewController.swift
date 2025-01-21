//
//  HomeViewController.swift
//  TechBookTimerApp
//
//  Created by 本坊康孝 on 2024/12/13.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    var bookDataList: [BookDataModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("TimeLineViewControllerが表示されました")

        // Do any additional setup after loading the view.
        configureNavigationBar()
        configureAddButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBookData()
        configureTableView()
        tableView.reloadData()
    }

    @IBAction func tappedAddButton(_ sender: UIButton) {
        print("EditViewControllerへ遷移します")
        navigateToRegistBookViewController()
    }

    func configureNavigationBar() {
        navigationItem.title = "ホーム"
    }

    func configureAddButton() {
        addButton.layer.cornerRadius = addButton.bounds.width / 2
    }

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .lightGray
        tableView.separatorStyle = .singleLine
        if #available(iOS 15.0, *) {
            tableView.fillerRowHeight = 50
        }

        let messageLabel = UILabel()
        messageLabel.text = "+ボタンから本の登録を行なってください"
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 15)
        messageLabel.sizeToFit()
        if bookDataList.isEmpty {
            tableView.backgroundView = messageLabel
        } else {
            tableView.backgroundView = nil
        }
    }

    func setBookData() {
        let realm = try! Realm()
        let result = realm.objects(BookDataModel.self)
        bookDataList = Array(result)
    }

    func navigateToRegistBookViewController() {
        let nextVC = RegistBookViewController(nibName: "RegistBookViewController", bundle: nil)
        let navi = UINavigationController(rootViewController: nextVC)
        navi.modalPresentationStyle = .fullScreen
        navigationController?.present(navi, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookDataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        // indexPath.row→UITableViewに表示されるCellの(0から始まる)通し番号が順番に渡される
        let bookDataModel: BookDataModel = bookDataList[indexPath.row]
        cell.textLabel?.text = bookDataModel.title
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = BookDetailViewController(nibName: "BookDetailViewController", bundle: nil)
        let bookData = bookDataList[indexPath.row]
        nextVC.configureBookData(with: bookData)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
