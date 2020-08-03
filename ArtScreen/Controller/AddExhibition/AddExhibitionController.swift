//
//  AddExhibitionController.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/1.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

//MARK: - paddingLabel settings
class PaddingLabel: UILabel {
    var insets = UIEdgeInsets.zero
    
    func padding(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width + left + right, height: self.frame.height + top + bottom)
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
            return contentSize
        }
    }
}

class AddExhibitionController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        iv.setDimensions(width: screenWidth, height: screenWidth)
        iv.backgroundColor = .mainPurple
        iv.image = #imageLiteral(resourceName: "coverImage")
        
        return iv
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.accessibilityIdentifier = "add_exhibition"
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSendAction() {
        let controller = ExhibitionUploadController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .black
        view.accessibilityIdentifier = "add_exhibition"
        configureNavigationBar()
        setupLayout()
    }
    
    func configureNavigationBar() {
        let navBar = navigationController?.navigationBar
        navigationController?.navigationBar.barStyle = .black
        
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Send").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSendAction))
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0)
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)

        stackView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingRight: 12)
        
        stackView.addArrangedSubview(coverImageView)
        stackView.addArrangedSubview(addTitleLabel(labelText: "Exhibition Title", paddingTop: 20, paddingLeft: 12))
        stackView.addArrangedSubview(addTextField(placeholder: "Title"))
        stackView.addArrangedSubview(addTitleLabel(labelText: "Introduction", paddingTop: 20, paddingLeft: 12))
        stackView.addArrangedSubview(addTextField(placeholder: "Introduction"))
        stackView.addArrangedSubview(addDivideLine())
        stackView.addArrangedSubview(addOnlineLabelAndSwitch())
    }
    
    //MARK: - Add Properties Helpers
    func addTitleLabel(labelText: String, paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0) -> PaddingLabel{
        let exhTitleLabel = PaddingLabel()
        exhTitleLabel.padding(paddingTop, paddingLeft, paddingBottom, paddingRight)
        exhTitleLabel.text = labelText
        exhTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        exhTitleLabel.textColor = .white

        return exhTitleLabel
    }
    
    func addTextField(placeholder: String) -> UITextField{
        let exhField = UITextField()
        exhField.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width * 0.1)
        exhField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        exhField.font = UIFont.systemFont(ofSize: 18)
        exhField.clearButtonMode = .whileEditing
        exhField.returnKeyType = .done
        exhField.textColor = .white
        exhField.tintColor = .mainPurple
        
        /// create a padding view for padding on left
        exhField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: exhField.frame.height))
        exhField.leftViewMode = .always
        
        //self.view.addSubview(exhField)
        hideKeyboardWhenTappedAround()
        exhField.delegate = self
        return exhField
    }
    
    func addDivideLine() -> UIView{
        let view = UIView()
        view.setDimensions(width: screenWidth, height: 0.75)
        view.backgroundColor = .white
        view.alpha = 0.87
        
        return view
    }

    func addOnlineLabelAndSwitch() -> UIStackView {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false

        let olSwitch = UISwitch()
        olSwitch.isOn = true
        
        stack.addArrangedSubview(addTitleLabel(labelText: "Online Exhibition", paddingLeft: 12))
        stack.addArrangedSubview(olSwitch)
        
        return stack
    }
}

//MARK: - Close Keyboard
extension AddExhibitionController {
    /// tap outside the textField to close the keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddExhibitionController.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
//MARK: - textField Delegate
extension AddExhibitionController {
    /// tap "done" button after finished typing to close the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
