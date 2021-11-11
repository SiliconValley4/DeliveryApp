//
//  PaymentMethodTypeCollectionView.swift
//  StripeiOS
//
//  Created by Yuki Tokuhiro on 12/4/20.
//  Copyright © 2020 Stripe, Inc. All rights reserved.
//

import Foundation
import UIKit
@_spi(STP) import StripeCore
@_spi(STP) import StripeUICore

protocol PaymentMethodTypeCollectionViewDelegate: AnyObject {
    func didUpdateSelection(_ paymentMethodTypeCollectionView: PaymentMethodTypeCollectionView)
}

// MARK: - Constants
private let paymentMethodLogoSize: CGSize = CGSize(width: UIView.noIntrinsicMetric, height: 12)
private let cellHeight: CGFloat = 52
private let minInteritemSpacing: CGFloat = 12

/// A carousel of Payment Method types e.g. [Card, Alipay, SEPA Debit]
class PaymentMethodTypeCollectionView: UICollectionView {
    let reuseIdentifier: String = "PaymentMethodTypeCollectionView.PaymentTypeCell"
    private(set) var selected: STPPaymentMethodType {
        didSet(old) {
            if old != selected {
                _delegate?.didUpdateSelection(self)
            }
        }
    }
    let paymentMethodTypes: [STPPaymentMethodType]
    weak var _delegate: PaymentMethodTypeCollectionViewDelegate?

    init(
        paymentMethodTypes: [STPPaymentMethodType],
        delegate: PaymentMethodTypeCollectionViewDelegate
    ) {
        self.paymentMethodTypes = paymentMethodTypes
        self._delegate = delegate
        self.selected = paymentMethodTypes[0]
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(
            top: 0, left: PaymentSheetUI.defaultPadding, bottom: 0,
            right: PaymentSheetUI.defaultPadding)
        layout.minimumInteritemSpacing = minInteritemSpacing
        super.init(frame: .zero, collectionViewLayout: layout)
        self.dataSource = self
        self.delegate = self
        selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])

        showsHorizontalScrollIndicator = false
        backgroundColor = CompatibleColor.systemBackground

        register(PaymentTypeCell.self, forCellWithReuseIdentifier: PaymentTypeCell.reuseIdentifier)
        clipsToBounds = false
        layer.masksToBounds = false
        accessibilityIdentifier = "PaymentMethodTypeCollectionView"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: cellHeight)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension PaymentMethodTypeCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
        -> Int
    {
        return paymentMethodTypes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PaymentMethodTypeCollectionView.PaymentTypeCell
                    .reuseIdentifier, for: indexPath)
                as? PaymentMethodTypeCollectionView.PaymentTypeCell
        else {
            assertionFailure()
            return UICollectionViewCell()
        }
        cell.paymentMethodType = paymentMethodTypes[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        selected = paymentMethodTypes[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Fixed size cells for iPad
        guard UIDevice.current.userInterfaceIdiom != .pad else { return CGSize(width: 100, height: cellHeight) }

        // Show 3 full cells plus 30% of the next if present
        let cellWidth = (collectionView.frame.width - (PaymentSheetUI.defaultPadding + (minInteritemSpacing * 3.0))) / 3.3
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - Cells

extension PaymentMethodTypeCollectionView {
    class PaymentTypeCell: UICollectionViewCell, EventHandler {
        static let reuseIdentifier = "PaymentTypeCell"
        var paymentMethodType: STPPaymentMethodType = .card {
            didSet {
                update()
            }
        }

        private lazy var label: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .medium, maximumPointSize: 20)
            label.adjustsFontSizeToFitWidth = true
            label.textColor = CompatibleColor.label
            return label
        }()
        private lazy var paymentMethodLogo: UIImageView = {
            let paymentMethodLogo = UIImageView()
            paymentMethodLogo.contentMode = .scaleAspectFit
            return paymentMethodLogo
        }()
        private lazy var shadowRoundedRectangle: ShadowedRoundedRectangle = {
            let shadowRoundedRectangle = ShadowedRoundedRectangle()
            shadowRoundedRectangle.underShadow.isHidden = true
            shadowRoundedRectangle.layer.borderWidth = 1
            shadowRoundedRectangle.layoutMargins = UIEdgeInsets(
                top: 15, left: 24, bottom: 15, right: 24)
            return shadowRoundedRectangle
        }()
        lazy var paymentMethodLogoWidthConstraint: NSLayoutConstraint = {
            paymentMethodLogo.widthAnchor.constraint(equalToConstant: 0)
        }()

        // MARK: - UICollectionViewCell

        override init(frame: CGRect) {
            super.init(frame: frame)

            [paymentMethodLogo, label].forEach {
                shadowRoundedRectangle.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

            isAccessibilityElement = true
            contentView.addSubview(shadowRoundedRectangle)
            shadowRoundedRectangle.frame = bounds
            
            NSLayoutConstraint.activate([
                paymentMethodLogo.topAnchor.constraint(
                    equalTo: shadowRoundedRectangle.topAnchor, constant: 12),
                paymentMethodLogo.leftAnchor.constraint(
                    equalTo: shadowRoundedRectangle.leftAnchor, constant: 12),
                paymentMethodLogo.heightAnchor.constraint(
                    equalToConstant: paymentMethodLogoSize.height),
                paymentMethodLogoWidthConstraint,

                label.topAnchor.constraint(equalTo: paymentMethodLogo.bottomAnchor, constant: 4),
                label.bottomAnchor.constraint(
                    equalTo: shadowRoundedRectangle.bottomAnchor, constant: -8),
                label.leftAnchor.constraint(equalTo: paymentMethodLogo.leftAnchor),
                label.rightAnchor.constraint(equalTo: shadowRoundedRectangle.rightAnchor, constant: -5),
            ])

            contentView.layer.cornerRadius = ElementsUI.defaultCornerRadius
            contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
            contentView.layer.shadowRadius = 1.5
            contentView.layer.shadowColor = UIColor.black.cgColor
            clipsToBounds = false
            layer.masksToBounds = false

            update()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            contentView.layer.shadowPath =
                UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius)
                .cgPath
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            update()
        }

        override var isSelected: Bool {
            didSet {
                update()
            }
        }

        // MARK: - Internal Methods

        func handleEvent(_ event: STPEvent) {
            UIView.animate(withDuration: PaymentSheetUI.defaultAnimationDuration) {
                switch event {
                case .shouldDisableUserInteraction:
                    self.label.alpha = 0.6
                case .shouldEnableUserInteraction:
                    self.label.alpha = 1
                }
            }
        }

        // MARK: - Private Methods
        private func update() {
            label.text = paymentMethodType.displayName
            let image = paymentMethodType.makeImage()
            paymentMethodLogo.image = image
            paymentMethodLogoWidthConstraint.constant = paymentMethodLogoSize.height / image.size.height * image.size.width
            setNeedsLayout()

            if isSelected {
                // Set shadow
                contentView.layer.shadowOpacity = PaymentSheetUI.defaultShadowOpacity
                shadowRoundedRectangle.shouldDisplayShadow = true

                // Set border
                shadowRoundedRectangle.layer.borderWidth = 2
                shadowRoundedRectangle.layer.borderColor = CompatibleColor.label.cgColor
            } else {
                // Hide shadow
                contentView.layer.shadowOpacity = 0
                shadowRoundedRectangle.shouldDisplayShadow = false

                // Set border
                shadowRoundedRectangle.layer.borderWidth = 0.5
                shadowRoundedRectangle.layer.borderColor = CompatibleColor.systemGray4.cgColor
            }
            accessibilityLabel = label.text
            accessibilityTraits = isSelected ? [.selected] : []
            accessibilityIdentifier = STPPaymentMethod.string(from: paymentMethodType)
        }
    }
}
