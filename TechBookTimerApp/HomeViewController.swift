//
//  HomeViewController.swift
//  TechBookTimerApp
//
//  Created by 本坊康孝 on 2024/12/13.
//

import UIKit

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
        configureTableView()
        setBookData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func tappedAddButton(_ sender: UIButton) {
        print("EditViewControllerへ遷移します")
        navigateToRegistBookViewController()
    }

    func setBookData() {
//        for i in 1...5 {
//            let bookDataModel = BookDataModel(title: "本\(i)")
//            bookDataList.append(bookDataModel)
//        }
    }

    func configureNavigationBar() {
        navigationItem.title = "ホーム"
    }

    func configureAddButton() {
        addButton.layer.cornerRadius = addButton.bounds.width / 2
    }

    func configureTableView() {
        tableView.dataSource = self
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

        tableView.backgroundView = messageLabel
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
