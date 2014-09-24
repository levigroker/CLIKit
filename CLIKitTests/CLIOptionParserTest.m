//
//  CLIOptionParserTest.m
//  CLIKit
//
//  Created by Michael James on 9/17/14.
//  Copyright (c) 2014 Maple Glen Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "CLIOptionParser.h"
#import "CLIOptionRequirement.h"

#import <string.h>

@interface CLIOptionParserTest : XCTestCase
{
    CLIOptionParser*    _optionParser;
}

@end

@implementation CLIOptionParserTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCanCreateWithArgumentsFromMain {
    _optionParser = [[CLIOptionParser alloc] init];
    XCTAssertNotNil(_optionParser);
}

- (void)testCanReadShortOptionsWithNoArguments {
    char* const*    cliArgs = [self createCommandlineArgumentsFromString: @"progname -v"];
    id              delegateMock = OCMProtocolMock(@protocol(CLIOptionParserDelegate));
    NSError*        error = nil;
    NSArray*        optionRequirements = @[ [CLIOptionRequirement optionRequirementForShortOption: @"v" canHaveArgument: NO thatIsRequired: NO] ];
    
    _optionParser = [[CLIOptionParser alloc] init];
    OCMExpect([delegateMock optionParserWillBeginParsing: _optionParser]);
    OCMExpect([delegateMock optionParser: _optionParser didEncounterOptionWithFlagName: @"v" flagValue: 'v' argument: nil]);
    OCMExpect([delegateMock optionParserDidFinishParsing: _optionParser]);
    
    _optionParser.delegate = delegateMock;
    BOOL resultSucceeded = [_optionParser parseCommandLineArguments: cliArgs count: 2 withOptionRequirements: optionRequirements error: &error];
    XCTAssertTrue(resultSucceeded, @"parseCommandLineArguments:count:error: returned NO");
    
    OCMVerifyAll(delegateMock);
    
    free((char**)cliArgs);
}

- (void)testCanReadShortOptionsWithArguments {
    char* const*    cliArgs = [self createCommandlineArgumentsFromString: @"progname -f filename"];
    id              delegateMock = OCMProtocolMock(@protocol(CLIOptionParserDelegate));
    NSError*        error = nil;
    NSArray*        optionRequirements = @[ [CLIOptionRequirement optionRequirementForShortOption: @"f" canHaveArgument: YES thatIsRequired: YES] ];
    
    _optionParser = [[CLIOptionParser alloc] init];
    OCMExpect([delegateMock optionParserWillBeginParsing: _optionParser]);
    OCMExpect([delegateMock optionParser: _optionParser didEncounterOptionWithFlagName: @"f" flagValue: 'f' argument: @"filename"]);
    OCMExpect([delegateMock optionParserDidFinishParsing: _optionParser]);
    
    _optionParser.delegate = delegateMock;
    BOOL resultSucceeded = [_optionParser parseCommandLineArguments: cliArgs count: 3 withOptionRequirements: optionRequirements error: &error];
    XCTAssertTrue(resultSucceeded, @"parseCommandLineArguments:count:error: returned NO");
    
    OCMVerifyAll(delegateMock);
    
    free((char**)cliArgs);
}

- (void)testCanReadLongOptionsWithNoArguments {
    char* const*    cliArgs = [self createCommandlineArgumentsFromString: @"progname --version"];
    id              delegateMock = OCMProtocolMock(@protocol(CLIOptionParserDelegate));
    NSError*        error = nil;
    NSArray*        optionRequirements = @[ [CLIOptionRequirement optionRequirementForLongOption: @"version" canHaveArgument: NO thatIsRequired: NO valueIfOptionUsed: 'v'] ];
    
    _optionParser = [[CLIOptionParser alloc] init];
    OCMExpect([delegateMock optionParserWillBeginParsing: _optionParser]);
    OCMExpect([delegateMock optionParser: _optionParser didEncounterOptionWithFlagName: @"version" flagValue: 'v' argument: nil]);
    OCMExpect([delegateMock optionParserDidFinishParsing: _optionParser]);
    
    _optionParser.delegate = delegateMock;
    BOOL resultSucceeded = [_optionParser parseCommandLineArguments: cliArgs count: 2 withOptionRequirements: optionRequirements error: &error];
    XCTAssertTrue(resultSucceeded, @"parseCommandLineArguments:count:error: returned NO");
    
    OCMVerifyAll(delegateMock);
    
    free((char**)cliArgs);
}

- (void)testCanReadLongOptionsWithArguments {
    char* const*    cliArgs = [self createCommandlineArgumentsFromString: @"progname --file filename"];
    id              delegateMock = OCMProtocolMock(@protocol(CLIOptionParserDelegate));
    NSError*        error = nil;
    NSArray*        optionRequirements = @[ [CLIOptionRequirement optionRequirementForLongOption: @"file" canHaveArgument: YES thatIsRequired: YES valueIfOptionUsed: 'f'] ];
    
    _optionParser = [[CLIOptionParser alloc] init];
    OCMExpect([delegateMock optionParserWillBeginParsing: _optionParser]);
    OCMExpect([delegateMock optionParser: _optionParser didEncounterOptionWithFlagName: @"file" flagValue: 'f' argument: @"filename"]);
    OCMExpect([delegateMock optionParserDidFinishParsing: _optionParser]);
    
    _optionParser.delegate = delegateMock;
    BOOL resultSucceeded = [_optionParser parseCommandLineArguments: cliArgs count: 3 withOptionRequirements: optionRequirements error: &error];
    XCTAssertTrue(resultSucceeded, @"parseCommandLineArguments:count:error: returned NO");
    
    OCMVerifyAll(delegateMock);
    
    free((char**)cliArgs);
}

- (void)testCanLeaveRemainingCommandlineArgumentsUntouched {
    char* const*    cliArgs = [self createCommandlineArgumentsFromString: @"progname --file filename arg1 arg2 arg3"];
    id              delegateMock = OCMProtocolMock(@protocol(CLIOptionParserDelegate));
    NSError*        error = nil;
    NSArray*        optionRequirements = @[ [CLIOptionRequirement optionRequirementForLongOption: @"file" canHaveArgument: YES thatIsRequired: YES valueIfOptionUsed: 'f'] ];
    NSArray*        remainingArguments = @[@"arg1", @"arg2", @"arg3"];
    
    _optionParser = [[CLIOptionParser alloc] init];
    OCMExpect([delegateMock optionParserWillBeginParsing: _optionParser]);
    OCMExpect([delegateMock optionParser: _optionParser didEncounterOptionWithFlagName: @"file" flagValue: 'f' argument: @"filename"]);
    OCMExpect([delegateMock optionParser: _optionParser didEncounterNonOptionArguments: remainingArguments]);
    OCMExpect([delegateMock optionParserDidFinishParsing: _optionParser]);
    
    _optionParser.delegate = delegateMock;
    BOOL resultSucceeded = [_optionParser parseCommandLineArguments: cliArgs count: 6 withOptionRequirements: optionRequirements error: &error];
    XCTAssertTrue(resultSucceeded, @"parseCommandLineArguments:count:error: returned NO");
    
    OCMVerifyAll(delegateMock);
    
    free((char**)cliArgs);
}

- (void)testReportsErrorWhenOptionMissingArgument {
    char* const*    cliArgs = [self createCommandlineArgumentsFromString: @"progname --file -- arg1 arg2 arg3"];
    id              delegateMock = OCMProtocolMock(@protocol(CLIOptionParserDelegate));
    NSError*        error = nil;
    NSArray*        optionRequirements = @[ [CLIOptionRequirement optionRequirementForLongOption: @"file" canHaveArgument: YES thatIsRequired: YES valueIfOptionUsed: 'f'] ];
    
    _optionParser = [[CLIOptionParser alloc] init];
    OCMExpect([delegateMock optionParserWillBeginParsing: _optionParser]);
    OCMExpect([delegateMock optionParserDidFinishParsing: _optionParser]);
    
    _optionParser.delegate = delegateMock;
    BOOL resultSucceeded = [_optionParser parseCommandLineArguments: cliArgs count: 6 withOptionRequirements: optionRequirements error: &error];
    XCTAssertFalse(resultSucceeded, @"parseCommandLineArguments:count:error: returned YES");
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqualObjects(CLIKitErrorDomain, error.domain);
    XCTAssertEqual(kMissingRequiredArgument, error.code);
    
    OCMVerifyAll(delegateMock);
    
    free((char**)cliArgs);
}

- (void)testReportsErrorWhenUnknownOptionEncountered {
    char* const*    cliArgs = [self createCommandlineArgumentsFromString: @"progname -file"];
    id              delegateMock = OCMProtocolMock(@protocol(CLIOptionParserDelegate));
    NSError*        error = nil;
    NSArray*        optionRequirements = @[ [CLIOptionRequirement optionRequirementForShortOption: @"f" canHaveArgument: NO thatIsRequired: NO],
                                            [CLIOptionRequirement optionRequirementForShortOption: @"i" canHaveArgument: NO thatIsRequired: NO] ];
    
    _optionParser = [[CLIOptionParser alloc] init];
    OCMExpect([delegateMock optionParserWillBeginParsing: _optionParser]);
    OCMExpect([delegateMock optionParserDidFinishParsing: _optionParser]);
    
    _optionParser.delegate = delegateMock;
    BOOL resultSucceeded = [_optionParser parseCommandLineArguments: cliArgs count: 2 withOptionRequirements: optionRequirements error: &error];
    XCTAssertFalse(resultSucceeded, @"parseCommandLineArguments:count:error: returned YES");
    XCTAssertNotNil(error, @"No error returned");
    XCTAssertEqualObjects(CLIKitErrorDomain, error.domain);
    XCTAssertEqual(kUnknownOption, error.code);
    
    OCMVerifyAll(delegateMock);
    
    free((char**)cliArgs);
}

- (char* const*)createCommandlineArgumentsFromString: (NSString*)commandString {
    NSArray* parts = [commandString componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSUInteger argCount = [parts count];
    
    char** args = (char**)malloc(argCount * sizeof(char*));
    
    for (NSUInteger index = 0; index < argCount; index++) {
        NSLog(@"command line part: %@", parts[index]);
        args[index] = (char*)[parts[index] cStringUsingEncoding: NSASCIIStringEncoding];
    }
    
    return args;
}

@end