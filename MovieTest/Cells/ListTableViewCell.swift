//
//  ListTableViewCell.swift
//  MovieTest
//
//  Created by Macbook Pro on 7/13/22.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    //MARK: Reuse ID
    static let identifier = debugDescription()
    
    //MARK: UI Element(s)
    
    lazy var movieTitle: UILabel = {
        let text = UILabel()
        text.backgroundColor = .clear
        text.text = "Select title"
        text.font = UIFont(name: "kefa", size: Utility.convertHeightMultiplier(constant: 18))
        text.textColor = .black
        text.textAlignment = .left
        text.numberOfLines = 2
        text.adjustsFontSizeToFitWidth = true
        return text
    }()
    
    
    lazy var review: UITextView = {
        let textView = UITextView()
        textView.text = "I am grateful for...."
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "kefa", size: 0.75 * Utility.convertHeightMultiplier(constant: 20))
        textView.autocorrectionType = .no
        textView.textColor = UIColor.black
        textView.backgroundColor = .white
        return textView
    }()
    
    lazy var poster: UIImageView = {
        let loveicon = UIImageView()
        loveicon.image = UIImage(named: "empty")
        loveicon.contentMode = .scaleAspectFill
        return loveicon
    }()
    
    lazy var containerView: UIView = {
        let container_view = UIView()
        container_view.backgroundColor = .white
        return container_view
    }()
    
    //MARK: Padding Variable(s)
    let padding: CGFloat = 35
    
    //MARK: Initializer(s)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        addConstraints()
    }
    
    //MARK: Helper Method(s)
    func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(review)
        containerView.addSubview(poster)
        containerView.addSubview(movieTitle)
    }
    
    func addConstraints() {
        
        containerView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(hexString: "#E9EAF0").cgColor
        review.leadingAnchor  .constraint(equalTo: containerView.leadingAnchor, constant: 95).isActive = true
        review.trailingAnchor .constraint(equalTo: containerView.trailingAnchor, constant: -padding).isActive = true
        review.topAnchor      .constraint(equalTo: containerView.topAnchor, constant: padding).isActive = true
        review.bottomAnchor   .constraint(equalTo: containerView.bottomAnchor, constant: -padding).isActive = true
        poster.anchor(top: nil, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        poster.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        movieTitle.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 100, paddingBottom: 0, paddingRight: 16, width: 0, height: 34)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


