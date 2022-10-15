//
//  Metric.swift
//  Password selection
//
//  Created by Артем Галай on 13.10.22.
//

import UIKit

extension PasswordViewController {
    struct MetricPasswordViewController {

        static let backgroundViewImage: UIImage = UIImage(named: "mainBackground") ?? UIImage()
        static let newBackgroundViewImage: UIImage = UIImage(named: "newBackground") ?? UIImage()
        static let startButtonImage: UIImage = UIImage(named: "password") ?? UIImage()
        static let changeBackgroundButtonImage: UIImage = UIImage(named: "change") ?? UIImage()
        static let stopButtonImage: UIImage = UIImage(named: "stop") ?? UIImage() 

        static let textFieldLayerCornerRadius: CGFloat = 15
        static let textFieldLayerBorderWidth: CGFloat = 2

        static let labelFontSize: CGFloat = 48
        
        static let changeBackgroundButtonBottomAnchorConstraint: CGFloat = -25
        static let changeBackgroundButtonWidthAnchorConstraint: CGFloat = 300
        static let changeBackgroundButtonHeightAnchorConstraint: CGFloat = 140

        static let startButtonTopAnchorConstraint: CGFloat = 310
        static let startButtonWidthAnchorConstraint: CGFloat = 120
        static let startButtonHeightAnchorConstraint: CGFloat = 120

        static let passwordTextFieldTopAnchorConstraint: CGFloat = 60
        static let passwordTextFieldWidthAnchorConstraint: CGFloat = 120
        static let passwordTextFieldHeightAnchorConstraint: CGFloat = 40
        
        static let guessedPasswordLabelTopAnchorConstraint: CGFloat = 10

        static let activityIndicatorViewTopAnchorConstraint: CGFloat = 10
        static let activityIndicatorViewHeightAnchorConstraint: CGFloat = 40
        static let activityIndicatorViewWidthAnchorConstraint: CGFloat = 40

        static let stopButtonWidthAnchorConstraint: CGFloat = 120
        static let stopButtonHeightAnchorConstraint: CGFloat = 120
    }
}
