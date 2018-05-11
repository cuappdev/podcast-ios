//
//  SearchFooterView.swift
//  Podcast
//
//  Created by Jack Thompson on 5/2/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//



import UIKit

protocol SearchFooterDelegate: class {
    func searchFooterDidPress(searchFooter: SearchFooterView)
}

class SearchFooterView: UIView {

    static let height:CGFloat = 100
    var noResultsLabel: UILabel!
    var searchITunesLabel: UILabel!
    
    let itunesLabelHeight:CGFloat = 34
    var topPadding: CGFloat = 20
    var padding: CGFloat = 12.5
    let margins: CGFloat = 70
    
    weak var delegate: SearchFooterDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        noResultsLabel = UILabel()
        noResultsLabel.text = "Can't find a series you're looking for?"
        noResultsLabel.textColor = .slateGrey
        noResultsLabel.font = ._14RegularFont()
        noResultsLabel.textAlignment = .center
        addSubview(noResultsLabel)
        
        noResultsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topPadding)
            make.leading.trailing.equalToSuperview()
        }
        
        searchITunesLabel = UILabel()
        searchITunesLabel.font = ._14RegularFont()
        searchITunesLabel.textColor = .slateGrey
        let attributedText = NSMutableAttributedString(string: "Search the web to add more series to our collection.")
        attributedText.addAttribute(.foregroundColor, value: UIColor.sea, range: NSRange(location: 0, length: 15))
        searchITunesLabel.attributedText = attributedText
        searchITunesLabel.textAlignment = .center
        searchITunesLabel.numberOfLines = 2
        addSubview(searchITunesLabel)
        
        searchITunesLabel.snp.makeConstraints { (make) in
            make.height.equalTo(itunesLabelHeight)
            make.leading.trailing.equalToSuperview().inset(margins)
            make.top.equalTo(noResultsLabel.snp.bottom).offset(padding)
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSearch)))
    }
    
    @objc func didTapSearch() {
        delegate?.searchFooterDidPress(searchFooter: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
