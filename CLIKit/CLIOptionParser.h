//
//  CLIOptionParser.h
//  CLIKit
//
//  Created by Michael James on 9/13/14.
//  Copyright (c) 2014 Michael James. All rights reserved.
//

#import <Foundation/Foundation.h>

/** NSError domain of errors coming from this library */
extern NSString* const CLIKitErrorDomain;

/** Error codes used by CLIOptionParser */
typedef enum {
    kMissingRequiredArgument = 1,
    kUnknownOption
} CLIOptionParserErrorCode;

@class CLIOptionParser;

/**
 Delegate that receives callbacks during the lifecycle of the CLIOptionParser's option-parsing process.
 */
@protocol CLIOptionParserDelegate <NSObject>

@required

/**
 Called when CLIOptionParser finds a command-line option that it was configured to recognize.
 
 @param parser The CLIOptionParser that encountered the option
 @param optionName The option name minus the "-" or "--", so it will be a single character for short options and multiple characters for long options
 @param optionArgument The argument for encountered option, nil if the option takes no argument or if the option can take an optional argument but none was supplied
 */
- (void)optionParser: (CLIOptionParser*)parser didEncounterOptionWithName: (NSString*)optionName argument: (NSString*)optionArgument;

/**
 Called when, after parsing command-line options, there are remaining command-line arguments for the program itself (not arguments for options).
 
 @param parser The CLIOptionParser that is calling this delegate
 @param remainingArguments An array of NSStrings representing each non-command-line argument, in the order given
 */
- (void)optionParser: (CLIOptionParser*)parser didEncounterNonOptionArguments: (NSArray*)remainingArguments;

@optional

/**
 Called before CLIOptionParser begins parsing command-line options.
 
 @param parser The CLIOptionParser that is about to begin parsing
 */
- (void)optionParserWillBeginParsing: (CLIOptionParser*)parser;

/**
 Called after CLIOptionParser finishes parsing command-line options.
 
 @param parser The CLIOptionParser that has just finished parsing command-line options
 */
- (void)optionParserDidFinishParsing: (CLIOptionParser*)parser;

@end

/**
 CLIOptionParser parses command-line options used to configure a command-line application
 
 In order to parse the command-line options, you will need to supply an array of CLIOption objects 
 that specify the following about each command-line option you want to process:
 
 - the name of the option (for short options, a single character (like -v); for long options, a string (like --verbose))
 - whether the option can be followed by an argument (for example: --file filename, where file is a long option name and filename is its argument)
 - if the option can take an argument, is the argument required?
 
 When parsing command-line options you need to assign a delegate object (that conforms 
 to the CLIOptionParserDelegate protocol) that will be called when the options you supplied 
 to the parsing method are encountered.
 */
@interface CLIOptionParser : NSObject

/** The delegate that will receive parsing lifecycle callbacks */
@property (weak, nonatomic) id<CLIOptionParserDelegate> delegate;

/**
 Parse the given command line arguments (as given in parameters to the program's main() method.
 
 @param arguments The command line arguments supplied as the argv parameter to the program's main() function
 @param argumentCount The number of arguments supplied as the argc parameter to the program's main() function
 @param optionsToRecognize An array of CLIOption objects specifying the command-line options the parser should recognize
 @param err If the parsing fails, and this parameter is not NULL, it will contain information about why the parse failed
 @return YES, if the parser was able to successfully parse the command-line options, NO otherwise (err parameter will contain information about the failure)
 */
- (BOOL)parseCommandLineArguments: (char* const*)arguments
                            count: (unsigned int)argumentCount
               optionsToRecognize: (NSArray*)optionsToRecognize
                            error: (NSError**)err;

@end

