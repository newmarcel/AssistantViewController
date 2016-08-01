//
//  AssistantViewControllerDelegate.swift
//  AssistantViewController
//
//  Created by Marcel Dierkes on 31.07.16.
//  Copyright © 2016 Marcel Dierkes. All rights reserved.
//

import UIKit

public protocol AssistantViewControllerDelegate: class {
    func assistantViewController(controller: AssistantViewController, willShow viewController: UIViewController, animated: Bool)
    func assistantViewController(controller: AssistantViewController, didShow viewController: UIViewController, animated: Bool)
}

public protocol AssistantViewControllerDataSource: class {
    func assistantViewControllerViewControllerForNextStep(controller: AssistantViewController) -> UIViewController?
}
