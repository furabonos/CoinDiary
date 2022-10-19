//
//  CoinCell.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/19.
//

import UIKit
import SnapKit

class CoinCell: BaseCollectionViewCell {
    
    lazy var coinLabel: UILabel = {
        var l = UILabel()
        return l
    }()
    
    lazy var lineView: UIView = {
        var v = UIView()
        v.backgroundColor = Colors.iosGrey
        return v
    }()
    
    override func setupUI() {
        [coinLabel, lineView].forEach { self.addSubview($0) }
    }
    
    override func setupConstraints() {
        coinLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.leading.equalToSuperview().offset(20)
        }
        
        lineView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configuration(coin: String) {
        self.coinLabel.text = coin
    }
    
}
