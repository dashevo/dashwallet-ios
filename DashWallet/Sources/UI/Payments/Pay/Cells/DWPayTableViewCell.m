//
//  Created by Andrew Podkovyrin
//  Copyright © 2019 Dash Core Group. All rights reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "DWPayTableViewCell.h"

#import "DWPayOptionModel.h"
#import "DWUIKit.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *TitleForOptionType(DWPayOptionModelType type) {
    switch (type) {
        case DWPayOptionModelType_ScanQR:
            return NSLocalizedString(@"Send by", @"Send by (scanning QR code)");
        case DWPayOptionModelType_Pasteboard:
            return NSLocalizedString(@"Send to", nil);
        case DWPayOptionModelType_NFC:
            return NSLocalizedString(@"Send to", nil);
    }
}

static NSString *DescriptionForOptionType(DWPayOptionModelType type) {
    switch (type) {
        case DWPayOptionModelType_ScanQR:
            return NSLocalizedString(@"Scanning QR code", @"(Send by) Scanning QR code");
        case DWPayOptionModelType_Pasteboard:
            return NSLocalizedString(@"Сopied address or QR", nil);
        case DWPayOptionModelType_NFC:
            return NSLocalizedString(@"NFC device", nil);
    }
}

static UIColor *DescriptionColor(DWPayOptionModelType type) {
    return [UIColor dw_darkTitleColor];
}


static NSString *ActionTitleForOptionType(DWPayOptionModelType type) {
    switch (type) {
        case DWPayOptionModelType_ScanQR:
            return NSLocalizedString(@"Scan", @"should be as short as possible");
        case DWPayOptionModelType_Pasteboard:
            return NSLocalizedString(@"Send", nil);
        case DWPayOptionModelType_NFC:
            return NSLocalizedString(@"Tap", @"Pay using NFC (should be as short as possible)");
    }
}

static UIImage *IconForOptionType(DWPayOptionModelType type) {
    UIImage *image = nil;
    switch (type) {
        case DWPayOptionModelType_ScanQR:
            image = [UIImage imageNamed:@"pay_scan_qr"];
            break;
        case DWPayOptionModelType_Pasteboard:
            image = [UIImage imageNamed:@"pay_copied_address"];
            break;
        case DWPayOptionModelType_NFC:
            image = [UIImage imageNamed:@"pay_nfc"];
            break;
    }
    NSCParameterAssert(image);

    return image;
}

static CGFloat const MAX_ALLOWED_BUTTON_WIDTH = 108.0;

@interface DWPayTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) NSLayoutConstraint *actionButtonWidth;

@end

@implementation DWPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.titleLabel.font = [UIFont dw_fontForTextStyle:UIFontTextStyleFootnote];
    self.descriptionLabel.font = [UIFont dw_fontForTextStyle:UIFontTextStyleSubheadline];

    self.actionButtonWidth = [self.actionButton.widthAnchor constraintGreaterThanOrEqualToConstant:0];
    self.actionButtonWidth.priority = UILayoutPriorityRequired - 10;
    self.actionButtonWidth.active = YES;

    // KVO

    [self mvvm_observe:DW_KEYPATH(self, model.details)
                  with:^(typeof(self) self, NSString *value) {
                      [self updateDetails];
                  }];
}

- (void)setModel:(nullable DWPayOptionModel *)model {
    _model = model;

    DWPayOptionModelType type = model.type;
    self.titleLabel.text = TitleForOptionType(type);
    self.iconImageView.image = IconForOptionType(type);

    [self.actionButton setTitle:ActionTitleForOptionType(type) forState:UIControlStateNormal];
    [self.actionButton sizeToFit];
    [self.delegate payTableViewCell:self
               didUpdateButtonWidth:MIN(MAX_ALLOWED_BUTTON_WIDTH, self.actionButton.bounds.size.width)];

    [self updateDetails];
}

- (void)setPreferredActionButtonWidth:(CGFloat)preferredActionButtonWidth {
    _preferredActionButtonWidth = preferredActionButtonWidth;
    self.actionButtonWidth.constant = preferredActionButtonWidth;
}

#pragma mark - Actions

- (IBAction)actionButtonAction:(UIButton *)sender {
    [self.delegate payTableViewCell:self action:sender];
}

#pragma mark - Private

- (void)updateDetails {
    DWPayOptionModelType type = self.model.type;
    NSString *details = self.model.details;
    self.descriptionLabel.text = DescriptionForOptionType(type);
    self.descriptionLabel.textColor = DescriptionColor(type);
    self.actionButton.enabled = YES;

#if SNAPSHOT
    if (type == DWPayOptionModelType_Pasteboard) {
        self.actionButton.accessibilityIdentifier = @"send_pasteboard_button";
    }
#endif /* SNAPSHOT */
}

@end

NS_ASSUME_NONNULL_END
