//
//  CalculatorViewController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/10/20.
//

import UIKit
import Combine
import SnapKit

class CalculatorViewController: BaseViewController {
    
    lazy var buttonView: UIView = {
        var v = UIView()
        return v
    }()
    
    lazy var scrollView: UIScrollView = {
        var sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsHorizontalScrollIndicator = false
        sv.delegate = self
        return sv
    }()
    
    //target 목표가
    lazy var targetBtn: UIButton = {
        var b = UIButton()
        b.setTitle("목표가", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.titleLabel?.textAlignment = .center
        b.tag = 0
        b.addTarget(self, action: #selector(clickMenu(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var targetView: UIView = {
        var v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var targetAvgField: UITextField = {
        var tf = UITextField()
        tf.addLeftPadding()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        tf.placeholder = "구매한 코인의 평단가를 입력해주세요."
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
    }()
    
    lazy var targetBuyField: UITextField = {
        var tf = UITextField()
        tf.addLeftPadding()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        tf.placeholder = "매수금액을 입력해주세요."
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
    }()
    
    lazy var targetGoalField: UITextField = {
        var tf = UITextField()
        tf.addLeftPadding()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        tf.placeholder = "목표금액을 입력해주세요."
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
    }()
    
    lazy var targetLabel: UILabel = {
        var l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()
    
    //물타기
    lazy var combineBtn: UIButton = {
        var b = UIButton()
        b.setTitle("물타기", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.titleLabel?.textAlignment = .center
        b.tag = 1
        b.addTarget(self, action: #selector(clickMenu(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var combineView: UIView = {
        var v = UIView()
        return v
    }()
    
    lazy var combineBeforeLabel: UILabel = {
        var l = UILabel()
        l.text = "현재 보유 코인"
        return l
    }()
    
    lazy var combineAfterLabel: UILabel = {
        var l = UILabel()
        l.text = "추가 매수 코인"
        return l
    }()
    
    lazy var combineBeforeAvgField: UITextField = {
        var tf = UITextField()
        tf.addLeftPadding()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        tf.placeholder = "기존 평단가"
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
    }()
    
    lazy var combineBeforeBuyField: UITextField = {
        var tf = UITextField()
        tf.addLeftPadding()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        tf.placeholder = "기존 투자금액"
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
    }()
    
    lazy var combineAfterAvgField: UITextField = {
        var tf = UITextField()
        tf.addLeftPadding()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        tf.placeholder = "새로운 평단가"
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
    }()
    
    lazy var combineAfterBuyField: UITextField = {
        var tf = UITextField()
        tf.addLeftPadding()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        tf.placeholder = "새로운 투자금액"
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
    }()
    
    lazy var combineResultBtn: UIButton = {
        var b = UIButton()
        b.setTitle("계산", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.addTarget(self, action: #selector(combineClick), for: .touchUpInside)
        return b
    }()
    
    //percent
    lazy var percentBtn: UIButton = {
        var b = UIButton()
        b.setTitle("퍼센트", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.titleLabel?.textAlignment = .center
        b.tag = 2
        b.addTarget(self, action: #selector(clickMenu(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var percentView: UIView = {
        var v = UIView()
        v.backgroundColor = .orange
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    public var viewModel: CalculatorViewModel!
    var subscriptions = Set<AnyCancellable>()
    
    let borders = CALayer()
    
    static func create(with viewModel: CalculatorViewModel) -> CalculatorViewController {
        let view = CalculatorViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        // 1.목표가 2.물타기 3.퍼센트
        //목표가뷰 - 입력: 평단가(필수), 투자금액(필수), 목표금액(선택), 목표퍼센트(선택) -> 아웃풋: 목표금액까지가려면 코인가격이 얼마나 올라야하는가, 목표금액이 내현재투자금액의 몇퍼센트인가, 내가 목표한 퍼센트가 되려면 얼마가 되야하는가
        //물타기뷰 - 입력: 기존매수평단, 구매금액 새로운매수평단, 구매금액 -> 아웃풋: 뉴평단, 뉴 수량, 금액?
        //
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        borders.frame = CGRect.init(x: 0, y: 30, width: 100, height: 2)
        borders.backgroundColor = UIColor.systemPink.cgColor
        self.targetBtn.layer.addSublayer(borders)
        
    }
    
    override func setupUI() {
        [buttonView, scrollView].forEach { self.view.addSubview($0) }
        [targetBtn, combineBtn, percentBtn].forEach { self.buttonView.addSubview($0) }
        [targetView, combineView, percentView].forEach { self.scrollView.addSubview($0) }
        
        //MARK: TargetView addsubView
        [targetAvgField, targetBuyField, targetGoalField, targetLabel].forEach { self.targetView.addSubview($0) }
        
        //MARK: CombineView addsubView
        [combineBeforeAvgField, combineBeforeBuyField, combineAfterAvgField, combineAfterBuyField, combineResultBtn, combineBeforeLabel, combineAfterLabel].forEach { self.combineView.addSubview($0) }
        
    }
    
    override func setupConstraints() {
        buttonView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.width.equalTo(300)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(buttonView.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        self.scrollView.contentSize = CGSize(width: Int(self.view.bounds.width) * 3, height: 0)
        targetView.frame = CGRect(x: 0, y: 0, width: Int(self.view.bounds.width), height: Int(self.view.bounds.height))
        combineView.frame = CGRect(x: Int(self.view.bounds.width), y: 0, width: Int(self.view.bounds.width), height: Int(self.view.bounds.height))
        percentView.frame = CGRect(x: Int(self.view.bounds.width) * 2, y: 0, width: Int(self.view.bounds.width), height: Int(self.view.bounds.height))
        
        targetBtn.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(100)
        }
        
        combineBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(targetBtn.snp.trailing)
            $0.width.equalTo(100)
        }
        
        percentBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(combineBtn.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        
        //MARK: TargetView snp
        targetAvgField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(Int(self.view.bounds.width) - 60)
            $0.height.equalTo(30)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        targetBuyField.snp.makeConstraints {
            $0.top.equalTo(targetAvgField.snp.bottom).offset(30)
            $0.centerX.equalTo(targetAvgField.snp.centerX)
            $0.width.equalTo(targetAvgField.snp.width)
            $0.height.equalTo(30)
        }
        
        targetGoalField.snp.makeConstraints {
            $0.top.equalTo(targetBuyField.snp.bottom).offset(30)
            $0.centerX.equalTo(targetAvgField.snp.centerX)
            $0.width.equalTo(targetAvgField.snp.width)
            $0.height.equalTo(30)
        }
        
        targetLabel.snp.makeConstraints {
            $0.top.equalTo(targetGoalField.snp.bottom).offset(50)
            $0.centerX.equalTo(targetAvgField.snp.centerX)
            $0.width.equalTo(targetAvgField.snp.width)
            
        }
        
        //MARK: CombineView snp
        combineBeforeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(30)
        }
        
        combineBeforeAvgField.snp.makeConstraints {
            $0.top.equalTo(combineBeforeLabel).offset(60)
            $0.width.equalTo(Int(self.view.bounds.width) - 60)
            $0.height.equalTo(30)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
        }

        combineBeforeBuyField.snp.makeConstraints {
            $0.top.equalTo(combineBeforeAvgField.snp.bottom).offset(30)
            $0.centerX.equalTo(combineBeforeAvgField.snp.centerX)
            $0.width.equalTo(combineBeforeAvgField.snp.width)
            $0.height.equalTo(30)
        }
        
        combineAfterLabel.snp.makeConstraints {
            $0.top.equalTo(combineBeforeBuyField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(30)
            $0.height.equalTo(30)
        }
        
        combineAfterAvgField.snp.makeConstraints {
            $0.top.equalTo(combineAfterLabel.snp.bottom).offset(30)
            $0.centerX.equalTo(combineBeforeBuyField.snp.centerX)
            $0.width.equalTo(combineBeforeBuyField.snp.width)
            $0.height.equalTo(30)
        }
        
        combineAfterBuyField.snp.makeConstraints {
            $0.top.equalTo(combineAfterAvgField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.width.equalTo(combineAfterAvgField.snp.width)
            $0.height.equalTo(30)
        }
        
        combineResultBtn.snp.makeConstraints {
            $0.top.equalTo(combineAfterBuyField.snp.bottom).offset(30)
            $0.centerX.equalTo(combineBeforeBuyField.snp.centerX)
            $0.width.equalTo(combineAfterAvgField.snp.width)
            $0.height.equalTo(30)
        }
    }
    
    @objc func clickMenu(_ sender: UIButton) {
        self.view.endEditing(true)
        moveBorder(tag: sender.tag)
        switch sender.tag {
        case 0:
            self.scrollView.contentOffset = CGPoint.zero
        case 1:
            self.scrollView.contentOffset = CGPoint(x: self.view.bounds.width, y: 0)
        case 2:
            self.scrollView.contentOffset = CGPoint(x: self.view.bounds.width * 2, y: 0)
        default:
            break
        }
    }
    
    func moveBorder(tag: Int) {
        switch tag {
        case 0:
            borders.frame = CGRect.init(x: 0, y: 30, width: 100, height: 2)
        case 1:
            borders.frame = CGRect.init(x: 100, y: 30, width: 100, height: 2)
        case 2:
            borders.frame = CGRect.init(x: 200, y: 30, width: 100, height: 2)
        default:
            break
        }
    }
    
    @objc func combineClick() {
        
        self.view.endEditing(true)
        
        guard let beforeAVG = combineBeforeAvgField.text else { return }
        guard let beforeBUY = combineBeforeBuyField.text else { return }
        guard let afterAVG = combineAfterAvgField.text else { return }
        guard let afterBUY = combineAfterBuyField.text else { return }
        
        var beforeQuanity = Double(beforeBUY.replacingOccurrences(of: ",", with: ""))! / Double(beforeAVG.replacingOccurrences(of: ",", with: ""))! // 기존 구매수량
        var afterQuanity = Double(afterBUY.replacingOccurrences(of: ",", with: ""))! / Double(afterAVG.replacingOccurrences(of: ",", with: ""))! // 새로운 구매수량
        
        var total = (Double(afterBUY.replacingOccurrences(of: ",", with: ""))! + Double(beforeBUY.replacingOccurrences(of: ",", with: ""))!) / (beforeQuanity + afterQuanity)
        
        showAlert(message: "최종 평단가는 \(total)이며 수량은 \(beforeQuanity + afterQuanity)개 이다.")
        
    }

}

extension CalculatorViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var xx = self.view.bounds.width
        if scrollView.contentOffset.x == 0 {
            self.moveBorder(tag: 0)
        }else if scrollView.contentOffset.x == xx {
            self.moveBorder(tag: 1)
        }else if scrollView.contentOffset.x == xx * 2 {
            self.moveBorder(tag: 2)
        }
    }
}

extension CalculatorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard var text = textField.text else {
            return true
        }
        
        text = text.replacingOccurrences(of: ",", with: "")
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if (string.isEmpty) {
            // delete
            if text.count > 1 {
                guard let price = Double.init("\(text.prefix(text.count - 1))") else {
                    return true
                }
                guard let result = numberFormatter.string(for: price) else {
                    return true
                }
                textField.text = "\(result)"
            }
            else {
                textField.text = ""
            }
        }
        else {
            // add
            guard let price = Double.init("\(text)\(string)") else {
                return true
            }
            guard let result = numberFormatter.string(for: price) else {
                return true
            }
            textField.text = "\(result)"
        }
        
        
        if textField == self.targetGoalField {
            guard let avg = self.targetAvgField.text else { return true }
            guard let buy = self.targetBuyField.text else { return true }
            guard let goal = self.targetGoalField.text else { return true }
            
            var quanity = Double(buy.replacingOccurrences(of: ",", with: ""))! / Double(avg.replacingOccurrences(of: ",", with: ""))!
            if goal != "" {
                var target = Double(goal.replacingOccurrences(of: ",", with: ""))! / quanity
                var percent = ((target - Double(avg.replacingOccurrences(of: ",", with: ""))!) / Double(avg.replacingOccurrences(of: ",", with: ""))! ) * 100
                targetLabel.text = "목표금액에 도달하려면 코인의 평단가가 \(Int(target))원(\(Int(percent))%) 변화해야 합니다."
            }
        }
        
        
        return false
    }
    
}
