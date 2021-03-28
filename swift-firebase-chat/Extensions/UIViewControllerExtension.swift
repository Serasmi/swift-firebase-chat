//
//  UIViewControllerExtension.swift
//  swift-firebase-chat
//
//  Created by Сергей Смирнов on 28.03.2021.
//

import UIKit

extension UIViewController {
    func showSimpleError(with text: String) {
        let ac = UIAlertController(title: "Error", message: text, preferredStyle: .alert)

        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(ac, animated: true)
    }
}
