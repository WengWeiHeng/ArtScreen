//
//  AddExhibitionController.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/1.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class AddExhibitionController: UIViewController {
    
    //MARK: - Properties
    var user: User?
    private var isOnline: Bool = true
    private let imagePicker = UIImagePickerController()
    private var exhibitionImage: UIImage?
    
    private var customConstraintY: NSLayoutConstraint!
    
    private let coverImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "coverImage").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.setDimensions(width: screenWidth, height: screenWidth)
        button.addTarget(self, action: #selector(selectExhibitionImage), for: .touchUpInside)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = AddExhibitionUtilities().customLabel(title: "Exhibition Title")
        
        return label
    }()
    
    private let titleTextField: UITextField = {
        let tf = AddExhibitionUtilities().customTextField(placeholder: "Title")
        
        return tf
    }()
    
    private let introductionLabel: UILabel = {
        let label = AddExhibitionUtilities().customLabel(title: "Introduction")
        
        return label
    }()
    
    private let introductionTextField: UITextField = {
        let tf = AddExhibitionUtilities().customTextField(placeholder: "Introduction")
        
        return tf
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setHeight(height: 0.75)
        
        return view
    }()
    
    private let onlineLabel: UILabel = {
        let label = AddExhibitionUtilities().customLabel(title: "Open online")
        
        return label
    }()
    
    private let olSwitch: UISwitch = {
        let olswitch = UISwitch()
        olswitch.isOn = true
        olswitch.addTarget(self, action: #selector(handleOnOff), for: .touchUpInside)
        
        return olswitch
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleOnOff() {
        if olSwitch.isOn {
            isOnline = true
        } else {
            isOnline = false
        }
    }
    
    @objc func selectExhibitionImage() {
        print("DEBUG: select image..")
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleSendAction() {
        if titleTextField.text == "" && introductionTextField.text == "" {
            showError("Please write something")
        } else {
            uploadExhibition()
        }
    }
    
    @objc func keyboardWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
        
        coverImageButton.isEnabled = false
    }
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
        
        coverImageButton.isEnabled = true
    }
    
    //MARK: - API
    func uploadExhibition() {
        guard let name = titleTextField.text else { return }
        guard let introduction = introductionTextField.text else { return }
        guard let exhibitionImage = exhibitionImage else {
            showError("Please select a image")
            return
        }
        
        let credentials = ExhibitionCredentials(name: name, introduction: introduction, exhibitionImage: exhibitionImage, online: isOnline)
        
        showLoader(true, withText: "Uploadding Exhibition")
        ExhibitionService.uploadExhibition(credentials: credentials) { error in
            if let error = error {
                self.showLoader(false)
                self.showError(error.localizedDescription)
                return
            }
            
            self.showLoader(false)
            let controller = ExhibitionUploadController()
            controller.user = self.user
            controller.exhibitionTitleText = name
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .black
        view.accessibilityIdentifier = "add_exhibition"
        configureNavigationBar()
        configureImagePicker()
        
        view.addSubview(coverImageButton)
        coverImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20)
        
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, titleTextField])
        titleStack.axis = .vertical
        titleStack.spacing = 4
        
        view.addSubview(titleStack)
        titleStack.anchor(top: coverImageButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        let introductionStack = UIStackView(arrangedSubviews: [introductionLabel, introductionTextField])
        introductionStack.axis = .vertical
        introductionStack.spacing = 4
        
        view.addSubview(introductionStack)
        introductionStack.anchor(top: titleStack.bottomAnchor, left: titleStack.leftAnchor, right: titleStack.rightAnchor, paddingTop: 20)
        
        view.addSubview(lineView)
        lineView.anchor(top: introductionStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20)
        
        view.addSubview(olSwitch)
        olSwitch.anchor(top: lineView.bottomAnchor, right: titleStack.rightAnchor, paddingTop: 20)
        
        view.addSubview(onlineLabel)
        onlineLabel.anchor(left: titleStack.leftAnchor)
        onlineLabel.centerY(inView: olSwitch)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureNavigationBar() {
        let navBar = navigationController?.navigationBar
        navigationController?.navigationBar.barStyle = .black
        
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Send").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSendAction))
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}

//MARK: - UIImagePickerControllerDelegate
extension AddExhibitionController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let exhibitionImage = info[.editedImage] as? UIImage else { return }
        self.exhibitionImage = exhibitionImage
        
        coverImageButton.setImage(exhibitionImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
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
