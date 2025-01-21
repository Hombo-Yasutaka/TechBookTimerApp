//
//  SectionDataModel.swift
//  TechBookTimerApp
//
//  Created by 本坊康孝 on 2025/01/14.
//

import Foundation
import RealmSwift

class SectionDataModel: Object {
    @Persisted var id: String = UUID().uuidString
    @Persisted var sectionName: String = ""
    @Persisted var studyTimeSeconds: Int = 0
    @Persisted(originProperty: "Sections") var parentBook: LinkingObjects<BookDataModel>
}
