//
//  Note+CoreDataClass.swift
//  AppForNotes
//
//  Created by Julia on 26/12/2022.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    var correctText: NSAttributedString {
        get {
            let string = try! NSAttributedString(
                data: text,
                options: [.documentType: NSAttributedString.DocumentType.rtf],
                documentAttributes: nil
            )
            return string
        }
        set(newValue) {
            text = try! newValue.data(
            from: NSRange(location: 0, length: newValue.string.count),
            documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf]
            )
        }
   }
}
