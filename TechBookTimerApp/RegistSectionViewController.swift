//
//  RegistSectionViewController.swift
//  TechBookTimerApp
//
//  Created by 本坊康孝 on 2025/01/14.
//

import UIKit
import RealmSwift

class RegistSectionViewController: UIViewController {

    @IBOutlet weak var sectionNameField: UITextField!
    
    var bookDataModel = BookDataModel()
    var sectionDataModel = SectionDataModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureNavigationBar()
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
        navigationItem.title = "章の登録"
    }

    func configureBookData(with book: BookDataModel) {
        self.bookDataModel = book
    }

    @objc func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc func didTapRegistButton() {
        if let sectionNameFieldText = sectionNameField.text, !sectionNameFieldText.isEmpty  {
            sectionDataModel.sectionName = sectionNameFieldText
            saveData()
            dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "登録に失敗しました", message: "章名を入力してください")
        }
    }

    func saveData() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(bookDataModel)
            bookDataModel.Sections.append(sectionDataModel)
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
