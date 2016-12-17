//
//  AssistantStepViewController.swift
//  AssistantViewController
//
//  Created by Marcel Dierkes on 31.07.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import UIKit

public protocol AssistantStepViewControllerProtocol: class {
    var assistantViewController: AssistantViewController? { get }
    
    var headerViewController: UIViewController? { get }
}

public extension AssistantStepViewControllerProtocol where Self: UIViewController {
    var assistantViewController: AssistantViewController? {
        return self.navigationController?.parent as? AssistantViewController
    }
    
    var headerViewController: UIViewController? {
        return self.assistantViewController?.primaryViewController
    }
}

public class AssistantStepViewController: UIViewController, AssistantStepViewControllerProtocol {
    @IBAction func pushNextStepViewController(_ sender: Any) {
        _ = self.assistantViewController?.pushNextViewController()
    }
    @IBAction func popToPreviousStepViewController(_ sender: Any) {
        _ = self.assistantViewController?.popToPreviousViewController()
    }
}
