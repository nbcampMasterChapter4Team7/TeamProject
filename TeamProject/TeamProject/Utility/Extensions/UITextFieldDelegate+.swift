//
//  UITextFieldDelegate+.swift
//  TeamProject
//
//  Created by iOS study on 4/28/25.
//

import UIKit

// MARK: - Methods
/// 텍스트 필드에서 영어, 숫자, 특수문자만 입력하도록 제한 =====
/// textField: 변경이 발생한 텍스트 필드를 나타내는 UITextField 객체
/// range: 변경이 일어날 범위를 나타내는 NSRange 객체, 현재 텍스트에서 변경될 부분
/// replacementString: 사용자가 입력한 새로운 문자열을 나타내는 String 객체
extension UITextFieldDelegate {
    func shouldAllowCharacters(in textField: UITextField, range: NSRange, replacementString string: String, allowedCharacters: CharacterSet) -> Bool {
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }
        return true
    }
}
