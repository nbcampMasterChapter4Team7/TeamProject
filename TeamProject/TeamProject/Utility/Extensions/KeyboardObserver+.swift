//
//  KeyboardObserver.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit

extension UIViewController {
    
    // MARK: - Methods
    
    /// 키보드 옵저버 추가
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 옵저버 제거
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 리턴 키 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - @objc Methods
    /// 키보드가 나타날 때 UI 조정
    @objc func keyboardWillShow(notification: NSNotification) {
        /// 키보드 크기에 맞게 UI 변경 시 아래 코드 활성화(현재 기본 0으로 세팅)
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -100
        }
    }
    
    /// 키보드가 사라질 때 UI 복원
    @objc func keyboardWillHide(notification: NSNotification) {
        /// 키보드 크기에 맞게 UI 변경 시 아래 코드 활성화(현재 기본 0으로 세팅)
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
}
