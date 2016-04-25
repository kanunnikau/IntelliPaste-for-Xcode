//
//  TextUtilities_Tests.m
//  IntelliPaste
//
//  Created by Robert Gummesson on 28/05/2014.
//  Copyright (c) 2014 Cane Media Limited. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TextUtilities.h"

@interface TextUtilities_Tests : XCTestCase

@end

@implementation TextUtilities_Tests

- (void)testHexStrings
{
    NSString *const expectedResult = @"[UIColor colorWithRed:255./255. green:18./255. blue:52./255. alpha:1.]";
    NSString *const expectedResultAlpha = @"[UIColor colorWithRed:255./255. green:18./255. blue:52./255. alpha:52./255.]";
    LanguageType const t = LanguageTypeObjectiveC;
    
    XCTAssertTrue([[TextUtilities colorsFromText:@"#FF1234" languageType:t] isEqualToString:expectedResult], @"Hashed hex not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"0xFF1234" languageType:t] isEqualToString:expectedResult], @"Prefixed hex not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"FF1234" languageType:t] isEqualToString:expectedResult], @"Uppercase hex not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"ff1234" languageType:t] isEqualToString:expectedResult], @"Lowercase hex not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"FF1234FF" languageType:t] isEqualToString:expectedResult], @"Alpha hex with 100%% alpha not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"FF123434" languageType:t] isEqualToString:expectedResultAlpha], @"Alpha hex with alpha not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@" FF1234 " languageType:t] isEqualToString:expectedResult], @"Hex with space not parsed correctly");
    
    XCTAssertNil([TextUtilities colorsFromText:@"FK1234" languageType:t], @"Non hex letters should return nil");
    XCTAssertNil([TextUtilities colorsFromText:@"FF123" languageType:t], @"Invalid length should return nil");
    XCTAssertNil([TextUtilities colorsFromText:@"FF12345" languageType:t], @"Invalid length should return nil");
    XCTAssertNil([TextUtilities colorsFromText:@"FF12" languageType:t], @"Missing blue channel should return nil");
}

- (void)testRgbStrings
{
    NSString *const expectedResult = @"[UIColor colorWithRed:255./255. green:18./255. blue:52./255. alpha:1.]";
    LanguageType const t = LanguageTypeObjectiveC;
    
    XCTAssertTrue([[TextUtilities colorsFromText:@"255, 18, 52" languageType:t] isEqualToString:expectedResult], @"Rgb with spaces not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"255,18,52" languageType:t] isEqualToString:expectedResult], @"Rgb without spaces not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"255,18, 52" languageType:t] isEqualToString:expectedResult], @"Rgb with mixed spaces not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"255 18 52" languageType:t] isEqualToString:expectedResult], @"RGB without commas not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"255  18 52" languageType:t] isEqualToString:expectedResult], @"RGB with multiple spaces not parsed correctly");
        XCTAssertTrue([[TextUtilities colorsFromText:@"255\t18\t52" languageType:t] isEqualToString:expectedResult], @"RGB with tabs not parsed correctly");
    
    XCTAssertNil([TextUtilities colorsFromText:@"255, 1818, 52" languageType:t], @"Invalid mid digit length should fail");
    XCTAssertNil([TextUtilities colorsFromText:@"255, 18" languageType:t], @"Missing blue channel should return nil");
    XCTAssertNil([TextUtilities colorsFromText:@"255, 18," languageType:t], @"Missing blue channel should return nil");
}

- (void)testSwiftFormatting
{
    NSString *const expectedResult = @"UIColor(red: 255/255, green: 18/255, blue: 52/255, alpha: 1)";
    NSString *const expectedResultAlpha = @"UIColor(red: 255/255, green: 18/255, blue: 52/255, alpha: 52/255)";
    LanguageType const t = LanguageTypeSwift;
    
    XCTAssertTrue([[TextUtilities colorsFromText:@"255, 18, 52" languageType:t] isEqualToString:expectedResult], @"Rgb with commas not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"FF123434" languageType:t] isEqualToString:expectedResultAlpha], @"Alpha hex with alpha not parsed correctly");
}

- (void)testStoryboardFormatting
{
    NSString *const expectedResult = @"FF1234";
    LanguageType const t = LanguageTypeInterfaceBuilder;
    
    XCTAssertTrue([[TextUtilities colorsFromText:@"255, 18, 52" languageType:t] isEqualToString:expectedResult], @"Rgb with commas not parsed correctly");
    XCTAssertTrue([[TextUtilities colorsFromText:@"#FF1234" languageType:t] isEqualToString:expectedResult], @"Rgb with commas not parsed correctly");
}

@end
