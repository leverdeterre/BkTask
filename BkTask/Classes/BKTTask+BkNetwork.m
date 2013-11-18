//
// The MIT License (MIT)
//
// Copyright (c) 2013 Backelite
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "BKTTask+BkNetwork.h"

#import "BKTURLRequestOperation.h"
#import "BKTJSONParsingOperation.h"
#import "BKTFileLoadingOperation.h"
#import "BKTBlockStepOperation.h"

@implementation BKTTask (BkNetwork)

+ (id) taskWithRequest:(NSURLRequest *)aRequest
{
    BKTTask *newtask = [BKTTask new];
    BKTURLRequestOperation *reqOp = [[BKTURLRequestOperation alloc] initWithRequest:aRequest];
    [newtask addStep:reqOp];
    return newtask;
}

+ (id) imageTaskWithRequest:(NSURLRequest *)aRequest
{
    BKTTask *newtask = [BKTTask new];
    
    //Load image from NSDocumentDirectory (local cache)
    NSString *imageNamed = [aRequest.URL lastPathComponent];
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *localImagePath = [documentsPath stringByAppendingPathComponent:imageNamed];
    BKTFileLoadingOperation *fileLoadingOperation = [BKTFileLoadingOperation fileLoadingOperationWithFileURL:[NSURL fileURLWithPath:localImagePath]];
    fileLoadingOperation.isAnOptionnalStep = YES;
    fileLoadingOperation.isAllowedToCallSuccessBlockDuringTaskLifeTime = YES; //Allow to call a first time the success block
    [newtask addStep:fileLoadingOperation];
    
    //DownLoad image with URL
    BKTURLRequestOperation *reqOp = [[BKTURLRequestOperation alloc] initWithRequest:aRequest];
    [newtask addStep:reqOp];
    
    // Adding a custom operation to threat the NSData from BKTURLRequestOperation
    BKTBlockStepOperation *writeDataStep = [BKTBlockStepOperation blockOperationWithInputKey:@"bodyData" outputKey:@"bodyData" block:^id(id input, NSError **error) {
        
        //Save image
        if ([input isKindOfClass:[NSData class]]) {
            NSData *data = input;
            [data writeToFile:localImagePath atomically:YES];
        }
        
        return input;
    }];
    
    [newtask addStep:writeDataStep];

    BKTFileLoadingOperation *file2LoadingOperation = [BKTFileLoadingOperation fileLoadingOperationWithFileURL:[NSURL fileURLWithPath:localImagePath]];
    file2LoadingOperation.isAnOptionnalStep = NO;
    [newtask addStep:file2LoadingOperation];
    
    return newtask;
}

+ (id) taskWithJSONRequest:(NSURLRequest *)aRequest
{
    BKTTask *task = [self taskWithRequest:aRequest];
    BKTJSONParsingOperation *jsonOp = [BKTJSONParsingOperation new];
    [task addStep:jsonOp];
    return task;
}


@end
