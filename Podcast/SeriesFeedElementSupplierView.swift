//
//  SeriesFeedElementSupplierView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class SeriesFeedElementSupplierView: UIView {
    
    var seriesSupplierView: SupplierView!
    
    init(series: Series) {
        super.init(frame: CGRect.zero)
        
        seriesSupplierView = SupplierView()
        seriesSupplierView.setupWithSeries(series: series)
        addSubview(seriesSupplierView)
        
        seriesSupplierView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
