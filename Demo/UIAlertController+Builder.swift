//
//  UIAlertController+Builder.swift
//  Face Frenzy
//
//  Created by Daniel Carmo on 2016-12-30.
//  Copyright © 2016 ModiFace Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    static func okAlert(withTitle title:String? = nil, withMessage message:String? = nil) -> UIAlertController.Builder {
        return UIAlertController.Builder()
            .withTitle(title)
            .withMessage(message)
            .addOkAction()
    }
    
    class Builder {
        private var preferredStyle:UIAlertControllerStyle = .alert
        private var title:String? = nil
        private var message:String? = nil
        private var actions:[UIAlertAction] = [UIAlertAction]()
        private var popoverSourceView:UIView? = nil
        private var sourceRect:CGRect? = nil
        
        init() { }
        
        func preferredStyle(_ style:UIAlertControllerStyle) -> Builder {
            self.preferredStyle = style
            return self
        }
        
        func withTitle(_ title:String?) -> Builder {
            self.title = unwrapStringAndLocalize(title)
            return self
        }
        
        func withMessage(_ message:String?) -> Builder {
            self.message = unwrapStringAndLocalize(message)
            return self
        }
        
        func withPopoverSourceView(_ view:UIView?) -> Builder {
            self.popoverSourceView = view
            return self
        }
        
        func withSourceRect(_ rect:CGRect?) -> Builder {
            self.sourceRect = rect
            return self
        }
        
        func addOkAction(handler:((UIAlertAction) -> Swift.Void)? = nil) -> Builder {
            return addDefaultActionWithTitle("OK", handler: handler)
        }
        
        func addDeleteAction(handler:((UIAlertAction) -> Swift.Void)? = nil) -> Builder {
            return addDestructiveActionWithTitle("Delete", handler: handler)
        }
        
        func addCancelAction(handler:((UIAlertAction) -> Swift.Void)? = nil) -> Builder {
            return addCancelActionWithTitle("Cancel", handler: handler)
        }
        
        func addDefaultActionWithTitle(_ title:String, handler:((UIAlertAction) -> Swift.Void)? = nil) -> Builder {
            return addActionWithTitle(title, style: .default, handler: handler)
        }
        
        func addDestructiveActionWithTitle(_ title:String, handler:((UIAlertAction) -> Swift.Void)? = nil) -> Builder {
            return addActionWithTitle(title, style: .destructive, handler: handler)
        }
        
        func addCancelActionWithTitle(_ title:String, handler:((UIAlertAction) -> Swift.Void)? = nil) -> Builder {
            return addActionWithTitle(title, style: .cancel, handler: handler)
        }
        
        func addActionWithTitle(_ title:String, style:UIAlertActionStyle, handler:((UIAlertAction) -> Swift.Void)?) -> Builder {
            let action = UIAlertAction(title: NSLocalizedString(title, comment: ""), style: style, handler: handler)
            actions.append(action)
            return self
        }
        
        func show(in viewController:UIViewController, animated:Bool = true, completion:(() -> Swift.Void)? = nil) {
            viewController.present(build(), animated: animated, completion: completion)
        }
        
        private func build() -> UIAlertController {
            let alert = UIAlertController(title: self.title, message: self.message, preferredStyle: self.preferredStyle)
            
            if let popoverSourceView = self.popoverSourceView {
                alert.popoverPresentationController?.sourceView = popoverSourceView
            }
            
            if let sourceRect = self.sourceRect {
                alert.popoverPresentationController?.sourceRect = sourceRect
            }
            
            actions.forEach { (action) in
                alert.addAction(action)
            }
            
            return alert
        }
        
        private func unwrapStringAndLocalize(_ value:String?) -> String? {
            guard let value = value else { return nil }
            return NSLocalizedString(value, comment: "")
        }
    }
}
