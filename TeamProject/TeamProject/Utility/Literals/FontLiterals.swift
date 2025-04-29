//
//  FontLiterals.swift
//  TeamProject
//
//  Created by yimkeul on 4/25/25.
//

import UIKit

enum FontLiterals {

    // MARK: - Login
    case LoginTitle
    case LoginDescription
    case LoginButtonText
    case LoginSignUpText
    case LoginPlaceholder

    // MARK: - SignUp
    case SignUpNickName
    case SignUpID
    case SignUpPassword
    case SignUpButtonText
    case SignUPPlaceholder

    // MARK: - Rent
    case RentKickboardID
    case RentBasicCharge
    case RentHourlyCharge
    case RentPauseButtonText
    case RentReturnButtonText

    // MARK: - Registration
    case RegistrationModalTitle
    case RegistrationKickboardPosition
    case RegistrationKickboardID
    case RegistrationBasicCharge
    case RegistrationHourlyCharge
    case RegistrationCancelButtonText
    case RegistrationRegisterButtonText


    // MARK: - MyPage
    case MyPageUserName
    case MyPageUsageHistory
    case MyPageTotalUsageHistoryLabel
    case MyPageRegistrationKickboardLabel
    case MyPageTotalRegistrationKickboardLabel
    case MyPageCustomerService
    case MyPageOthers
    case MyPageRentalButtonText
    case MyPageLogoutButton

    // MARK: - UsageHistory
    case UsageHistoryKickboardID
    case UsageHistoryDate
    case UsageHistoryUseTime
    case UsageHistoryDistance
    case UsageHistoryCharge

    // MARK: - RegistrationHistory
    case RegistrationHistoryKickboardID
    case RegistrationHistoryDate
    case RegistrationHistoryBasicCharge
    case RegistrationHistoryHourlyCharge
    
    // MARK: - TabBar
    case TabBarTitle
}

extension FontLiterals {

    var size: CGFloat {
        switch self {
        case .LoginTitle: return 31
        case .LoginDescription, .LoginSignUpText: return 15
        case .LoginButtonText: return 21
        case .LoginPlaceholder: return 17

        case .SignUpNickName, .SignUpID,
             .SignUpPassword, .SignUPPlaceholder: return 17
        case .SignUpButtonText: return 21

        case .RentKickboardID: return 23
        case .RentBasicCharge, .RentHourlyCharge,
             .RentPauseButtonText, .RentReturnButtonText: return 17

        case .RegistrationModalTitle: return 17
        case .RegistrationKickboardPosition,
             .RegistrationKickboardID: return 15
        case .RegistrationBasicCharge,
             .RegistrationHourlyCharge: return 10
        case .RegistrationCancelButtonText,
             .RegistrationRegisterButtonText: return 15

        case .MyPageUserName: return 28
        case .MyPageUsageHistory,
             .MyPageCustomerService,
             .MyPageRegistrationKickboardLabel: return 15
        case .MyPageLogoutButton: return 11
        case .MyPageTotalUsageHistoryLabel,
             .MyPageTotalRegistrationKickboardLabel,
             .MyPageOthers: return 17
        case .MyPageRentalButtonText: return 20

        case .UsageHistoryKickboardID: return 15
        case .UsageHistoryDate: return 13
        case .UsageHistoryUseTime, .UsageHistoryDistance: return 10
        case .UsageHistoryCharge: return 14

        case .RegistrationHistoryKickboardID: return 15
        case .RegistrationHistoryDate: return 13
        case .RegistrationHistoryBasicCharge,
             .RegistrationHistoryHourlyCharge: return 10
            
        case .TabBarTitle: return 17
        }
    }

    var weight: UIFont.Weight {
        switch self {
        case .LoginTitle,
             .LoginButtonText,
             .SignUpButtonText,
             .RentKickboardID,
             .RentBasicCharge,
             .RentHourlyCharge,
             .RentPauseButtonText,
             .RentReturnButtonText,
             .RegistrationBasicCharge,
             .RegistrationHourlyCharge,
             .RegistrationCancelButtonText,
             .RegistrationRegisterButtonText,
             .MyPageUserName,
             .MyPageRentalButtonText,
             .UsageHistoryKickboardID,
             .UsageHistoryDate,
             .UsageHistoryUseTime,
             .UsageHistoryDistance,
             .UsageHistoryCharge,
             .RegistrationHistoryKickboardID,
             .RegistrationHistoryDate,
             .RegistrationHistoryBasicCharge,
             .RegistrationHistoryHourlyCharge,
             .TabBarTitle
            : return .bold

        case .SignUpNickName,
             .SignUpID,
             .SignUpPassword,
             .RegistrationModalTitle,
             .MyPageUsageHistory,
             .MyPageCustomerService,
             .MyPageRegistrationKickboardLabel,
             .MyPageTotalUsageHistoryLabel,
             .MyPageTotalRegistrationKickboardLabel,
             .MyPageOthers
            : return.semibold

        case .LoginPlaceholder,
             .LoginDescription,
             .LoginSignUpText,
             .SignUPPlaceholder,
             .RegistrationKickboardPosition,
             .RegistrationKickboardID,
             .MyPageLogoutButton
            : return .regular
        }
    }
}
