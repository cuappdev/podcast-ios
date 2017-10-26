//
//  ClearSearchFooterView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/26/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol ClearSearchFooterViewDelegate: class {
    func didPressClearSearchHistoryButton()
}

class ClearSearchFooterView: UIView {
    
    let height: CGFloat = PreviousSearchResultTableViewCell.height
    let xEdgePadding: CGFloat = 48

    var clearSearchButton: UIButton!
    weak var delegate: ClearSearchFooterViewDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        
        clearSearchButton = UIButton()
        clearSearchButton.contentHorizontalAlignment = .left
        clearSearchButton.setTitle("Clear Search History", for: .normal)
        clearSearchButton.setTitleColor(.sea, for: .normal)
        clearSearchButton.titleLabel!.font = ._14RegularFont()
        clearSearchButton.titleLabel!.textAlignment = .left
        clearSearchButton.addTarget(self, action: #selector(didPressClearSearchHistoryButton), for: .touchUpInside)
        addSubview(clearSearchButton)
        
        clearSearchButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.leading.equalToSuperview().inset(xEdgePadding)
            make.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPressClearSearchHistoryButton() {
        delegate?.didPressClearSearchHistoryButton()
    }
}
