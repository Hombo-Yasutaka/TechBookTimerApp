//
//  BookDataModel.swift
//  TechBookTimerApp
//
//  Created by 本坊康孝 on 2024/12/17.
//

import Foundation
import RealmSwift

class BookDataModel: Object {
    @Persisted var id: String = UUID().uuidString
    @Persisted var title: String = ""
    @Persisted var imageUrl: String = ""
    @Persisted var Sections: List<SectionDataModel>
}
