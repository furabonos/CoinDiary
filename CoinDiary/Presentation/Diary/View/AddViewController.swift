//
//  AddViewController.swift
//  CoinDiary
//
//  Created by 엄태형 on 2022/09/21.
//

import UIKit
import SnapKit
import Combine
import DLRadioButton

class AddViewController: BaseViewController {
    
    lazy var dateLabel: UILabel = {
        var l = UILabel()
        l.text = "기록일"
        return l
        
    }()
    
    lazy var dateField: LeftPaddingLabel = {
        var l = LeftPaddingLabel()
        l.text = "\(Date().getToday)"
        l.layer.borderColor = UIColor.gray.cgColor
        l.layer.borderWidth = 0.5
        l.layer.cornerRadius = 10
        return l
    }()
    
    lazy var startLabel: UILabel = {
        var l = UILabel()
        l.text = "시작시드"
        return l
    }()
    
    lazy var startField: UITextField = {
        var tf = UITextField()
        tf.delegate = self
        tf.addLeftPadding()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        tf.keyboardType = .decimalPad
        tf.text = UserDefaults.standard.string(forKey: "CurrentSeed") == nil ? "" : UserDefaults.standard.string(forKey: "CurrentSeed")!
        return tf
    }()
    
    lazy var endLabel: UILabel = {
        var l = UILabel()
        l.text = "종료시드"
        return l
    }()
    
    lazy var endField: UITextField = {
        var tf = UITextField()
        tf.delegate = self
        tf.addLeftPadding()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    lazy var memoLabel: UILabel = {
        var l = UILabel()
        l.text = "메모"
        return l
    }()
    
    lazy var memoField: UITextView = {
        var tf = UITextView()
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.5
        tf.layer.cornerRadius = 10
        return tf
    }()
    
    lazy var photoBtn: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(systemName: "photo"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.addTarget(self, action: #selector(getPhoto(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var imageView: UIImageView = {
        var iv = UIImageView()
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    lazy var addBtn: UIButton = {
        var b = UIButton()
        b.setTitle("확인", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.addTarget(self, action: #selector(clickAdd(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var cancelBtn: UIButton = {
        var b = UIButton()
        b.setTitle("취소", for: .normal)
        b.setTitleColor(.systemBlue, for: .normal)
        b.addTarget(self, action: #selector(clickCancel(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        var iv = UIActivityIndicatorView()
        return iv
    }()
    
    lazy var radioBtn1: DLRadioButton = {
        var b = DLRadioButton()
        b.setTitle("매매", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.addTarget(self, action: #selector(clickRadio(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var radioBtn2: DLRadioButton = {
        var b = DLRadioButton()
        b.setTitle("입금", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.addTarget(self, action: #selector(clickRadio(_:)), for: .touchUpInside)
        return b
    }()
    
    lazy var radioBtn3: DLRadioButton = {
        var b = DLRadioButton()
        b.setTitle("출금", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.addTarget(self, action: #selector(clickRadio(_:)), for: .touchUpInside)
        return b
    }()
    
    var images: UIImage!
    
    var pictureView = PictureView(frame: .zero, image: nil)
    
    public var viewModel: AddViewModel!
    var subscriptions = Set<AnyCancellable>()
    var types = "매매"
    
    static func create(with viewModel: AddViewModel) -> AddViewController {
        let view = AddViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        //입력할것 시작금액 종료금액 메모 사진 , 날짜는 자동세팅
        let tabGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickImageView(_:)))
        imageView.addGestureRecognizer(tabGestureRecognizer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func setupUI() {
        [dateLabel, dateField, startLabel, startField, endLabel, endField, memoLabel, memoField, photoBtn, imageView, addBtn, cancelBtn, indicatorView, radioBtn1, radioBtn2, radioBtn3].forEach { self.view.addSubview($0) }
        radioBtn1.otherButtons.append(radioBtn2)
        radioBtn1.otherButtons.append(radioBtn3)
        radioBtn1.isSelected = true
    }
    
    override func setupConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        
        dateField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        startLabel.snp.makeConstraints {
            $0.top.equalTo(dateField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        
        startField.snp.makeConstraints {
            $0.top.equalTo(startLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        endLabel.snp.makeConstraints {
            $0.top.equalTo(startField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        
        endField.snp.makeConstraints {
            $0.top.equalTo(endLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(30)
        }
        
        memoLabel.snp.makeConstraints {
            $0.top.equalTo(endField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        
        memoField.snp.makeConstraints {
            $0.top.equalTo(memoLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
        
        photoBtn.snp.makeConstraints {
            $0.top.equalTo(memoField.snp.bottom).offset(100)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(50)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(memoField.snp.bottom).offset(10)
            $0.trailing.equalTo(memoField.snp.trailing)
            $0.width.height.equalTo(60)
        }
        
        addBtn.snp.makeConstraints {
            $0.centerY.equalTo(photoBtn.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        
        cancelBtn.snp.makeConstraints {
            $0.centerY.equalTo(photoBtn.snp.centerY)
            $0.trailing.equalTo(addBtn.snp.leading).offset(-10)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        radioBtn1.snp.makeConstraints {
            $0.top.equalTo(memoField.snp.bottom).offset(10)
            $0.leading.equalTo(memoField.snp.leading)
            $0.height.equalTo(25)
            $0.width.equalTo(60)
        }
        
        radioBtn2.snp.makeConstraints {
            $0.top.equalTo(memoField.snp.bottom).offset(10)
            $0.leading.equalTo(radioBtn1.snp.trailing)
            $0.height.equalTo(25)
            $0.width.equalTo(60)
        }
        
        radioBtn3.snp.makeConstraints {
            $0.top.equalTo(memoField.snp.bottom).offset(10)
            $0.leading.equalTo(radioBtn2.snp.trailing)
            $0.height.equalTo(25)
            $0.width.equalTo(60)
        }
    }
    
    override func bind() {
        viewModel.viewDismissalModePublisher
            .receive(on: RunLoop.main)
            .sink { [unowned self] value in
                if value {
                    self.dismiss(animated: true)
                }
            }.store(in: &subscriptions)
        
        viewModel.saveDataPublisher.receive(on: RunLoop.main)
            .sink { [unowned self] value in
                if value {
                    saveDataSuccess(message: "저장되었습니다.")
                }else {
                    saveDataFailure(message: "저장에 실패하였습니다.\n잠시후 다시 시도해주세요.", indicator: self.indicatorView)
                }
            }.store(in: &subscriptions)
    }
    
    @objc func getPhoto(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @objc func clickImageView(_ sender: AnyObject) {
        self.pictureView = PictureView(frame: .zero, image: self.images)
        pictureView.delegate = self
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(pictureView)
        pictureView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    @objc func clickCancel(_ sender: UIButton) {
        viewModel.clickCancel()
    }
    
    @objc func clickAdd(_ sender: UIButton) {
        //날짜 시작금액 종료금액 메모
        var start = startField.text ?? ""
        var end = endField.text ?? ""
        var memo = memoField.text ?? ""
        var images = imageView.image
        
        if start == "" {
            showAlert(message: "시작금액을 입력해주세요.")
        }else if end == "" {
            showAlert(message: "종료금액을 입력해주세요.")
        }else {
            UserDefaults.standard.set(end, forKey: "CurrentSeed")
            indicatorView.startAnimating()
            viewModel.saveData(date: Date().getToday, start: start, end: end, memo: memo, type: self.types, image: images)
            
        }
    }
    
    @objc func clickRadio(_ sender: DLRadioButton) {
        guard let titles = sender.currentTitle else { return }
        self.types = titles
        print(self.types)
    }
    
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.images = image
            imageView.image = image
            imageView.isUserInteractionEnabled = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddViewController: PictureDelegate {
    func clickMore(_ sender: UIButton) {
        pictureView.removeFromSuperview()
    }
    
    func clickDelete(_ sender: UIButton) {
        pictureView.removeFromSuperview()
        imageView.image = nil
        imageView.isUserInteractionEnabled = false
    }
}

extension AddViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard var text = textField.text else {
            return true
        }
        
        text = text.replacingOccurrences(of: getStringUserDefaults(key: "unit"), with: "")
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
            textField.text = "\(result)\(getStringUserDefaults(key: "unit"))"
        }
        return false
    }
    
}

