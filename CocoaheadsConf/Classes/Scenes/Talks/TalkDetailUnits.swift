//
//  TalkDetailUnits.swift
//  CocoaheadsConf
//
//  Created by Bruno Bilescky on 21/11/16.
//  Copyright © 2016 Cocoaheads. All rights reserved.
//

import UIKit
import Compose
import Kingfisher

struct TalkDetailUnits {

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, HH:mm"
        return formatter
    }()
    
    static func Header(for talk: TalkModel, goBack: (()-> Void)?)-> ComposingUnit {
        let height = DimensionUnit { size in
            let reducedSize = CGSize(width: size.width - 146, height: size.height)
            let font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
            let attributed = NSAttributedString(string: talk.title, attributes: [NSFontAttributeName: font])
            let frame = attributed.boundingRect(with: reducedSize, options: .usesLineFragmentOrigin, context: nil)
            return frame.height + 90
        }
        let header = ViewUnit<DetailHeaderCollectionViewCell>(id: "header", traits: [.height(height)]) { view in
            view.talkNameLabel.text = talk.title
            view.talkTimeLabel.text = formatter.string(from: talk.date)
            view.talkLocationLabel.text = talk.room?.title
            view.talkIndicatorView.backgroundColor = talk.type.color
            view.backButton.tintColor = talk.type.color
            view.tapGoBackCallback = goBack
            view.talkSpeakerImageView.kf.setImage(with: talk.speaker?.imageURL, placeholder: ConferenceStyleKit.imageOfCocoaHeadsLogo, options: nil, progressBlock: nil, completionHandler: nil)
            view.talkSpeakerImageView.isHidden = !talk.type.hasImage
        }
        return header
    }
    
    static func Description(for talk: TalkModel)-> ComposingUnit {
        let summaryFont = UIFont.systemFont(ofSize: 22, weight: UIFontWeightMedium)
        let descriptionFont = UIFont.systemFont(ofSize: 14)
        let attributedSummary = NSAttributedString(string: talk.summary, attributes: [NSFontAttributeName: summaryFont])
        let attributedDescription = NSAttributedString(string: talk.fullDescription, attributes: [NSFontAttributeName: descriptionFont])
        let height = DimensionUnit { size in
            let reducedSize = CGSize(width: size.width - 32, height: size.height)
            let summaryFrame = attributedSummary.boundingRect(with: reducedSize, options: .usesLineFragmentOrigin, context: nil)
            let descriptionFrame = attributedDescription.boundingRect(with: reducedSize, options: .usesLineFragmentOrigin, context: nil)
            return summaryFrame.height + descriptionFrame.height + 56
        }
        let unit = ViewUnit<TalkDetailDescriptionCollectionViewCell>(id: "description", traits: [.height(height)]) { view in
            view.summaryLabel.attributedText = attributedSummary
            view.descriptionLabel.attributedText = attributedDescription
        }
        return unit
    }
    
}
