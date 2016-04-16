//
//  NSLogn.m
//  hacfun
//
//  Created by Ben on 16/3/29.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "NSLogn.h"
#import "AsyncSocket.h"
#import "GCDAsyncSocket.h"
#import "FuncDefine.h"
#include <stdio.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
/*
  NSLog重新定义.
  此文件中所有接口不能调用NSLog, 
  否则触发循环调用.
  调用NSLogo,
  调用NSLog0 取消打印.
 */
#define NSLogo(FORMAT, ...) { NSString *content = [NSString stringWithFormat:FORMAT, ##__VA_ARGS__]; printf("------ %s\n", [content UTF8String]);}
#define NSLog0(FORMAT, ...)
 

@interface NSLogn ()<AsyncSocketDelegate>

@property (nonatomic, strong) AsyncSocket *socket;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, strong) NSMutableString *storeString; //未连接时的log信息存起来.
@property (nonatomic, assign) NSInteger lengthClear;
@property (nonatomic, assign) NSInteger lengthLogMesseageTotal;
@property (atomic,    assign) NSInteger sn;



@property (nonatomic, strong) NSThread *thread;

@end

#define SERVER_ADDR "192.168.1.4"
//#define SERVER_ADDR "49.51.9.147"
#define SERVER_PORT 12346

@implementation NSLogn


+ (NSInteger)retainCount:(unsigned long long)objAddr
{
    return CFGetRetainCount((CFTypeRef)objAddr);
}


+ (NSInteger)retainCount1:(__weak id)anObject
{
    __weak id wid = anObject;
    return CFGetRetainCount((CFTypeRef)wid);
}


+ (NSInteger)retainCount0:(id)myObject
{
    return CFGetRetainCount((__bridge CFTypeRef)myObject);
}


/*
 长连接发送tcp方式.
 1.主线程中使用AsyncSocket.
 2.使用常驻NSThread, 主线程performSelector的形式添加发送任务.
 3.增加pthread线程，同步发送数据.
*/

+ (NSLogn *)sharedNSLogn {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)dealloc
{
    NSLogo(@"dealloc.");
}


- (void)sendLogContent:(NSString *)logString
{
    [self sendLogContent1:logString];
}


- (void)repeatDetect
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLogo(@"connected ? : %d", [self.socket isConnected]);
        [self repeatDetect];
    });
}


- (void)connect
{
    NSLogo(@" connnect");
    
    //AsyncSocket *socket = [[AsyncSocket alloc] initWithDelegate:self];
    //[socket connectToHost:@SERVER_ADDR onPort:SERVER_PORT withTimeout:10 error:nil];
    
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    [self.socket connectToHost:@SERVER_ADDR onPort:SERVER_PORT withTimeout:10 error:nil];
    
    //[self repeatDetect];
    
#if 0
    return;
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    NSError *err = nil;
//    BOOL bconnect = [self.socket connectToHost:@SERVER_ADDR onPort:SERVER_PORT error:&err];
        NSLogo(@"connect start.");
    BOOL bconnect = [self.socket connectToHost:@SERVER_ADDR onPort:SERVER_PORT withTimeout:2.0 error:&err];
    if(bconnect) {
        NSLogo(@"connected to.");
    }
    else {
        NSLogo(@"connected failed : %@.", err);
    }
#endif
}


- (void)disconnect
{
    NSLogo(@"disconnect.");
    [self.socket disconnect];
    self.socket = nil;
}

#define KNSSTRING_SEGMENT_HEADER @" G@p"

-(void)sendLogContent1:(NSString*)logString
{
    NSLog0(@" sendLogContent1 : %zd", logString.length);
    if(self.connected) {
        //NSLogo(@"data : %@", data);
        if(self.storeString.length > 0) {
            NSLog0(@"@@@@@@ send store message : %@", self.storeString);
            [self.socket writeData:[[NSString stringWithString:self.storeString] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
            self.storeString = [[NSMutableString alloc] init];
        }
        
        NSData *data = [[NSString stringWithFormat:@"%@%@", logString, KNSSTRING_SEGMENT_HEADER] dataUsingEncoding:NSUTF8StringEncoding];
        [self.socket writeData:data withTimeout:-1 tag:0];
    }
    else {
        static NSInteger klen = 0;
        klen += logString.length;
        NSLog0(@" add to store +%zd <totoal : %zd>", logString.length, klen);
        if(!self.storeString) {
            self.storeString = [[NSMutableString alloc] init];
        }
        
        [self.storeString appendString:[NSString stringWithFormat:@"%@%@", logString, KNSSTRING_SEGMENT_HEADER]];
        
        if((self.storeString.length - self.lengthClear) > (1024 * 100)) {
            self.lengthLogMesseageTotal += self.storeString.length;
            self.storeString = [[NSMutableString alloc] init];
            NSLogo(@"log message total %zd.", self.storeString.length);
        }
    }
}


-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLogo(@"成功连接服务端：%@", host);
    self.connected = YES;
    
    //发送数据给服务端
    //NSString *message = @" 服务器，你好 ！ ";
    //NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    //[sock writeData:data withTimeout:-1 tag:100]; //发送数据
}


-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    
    
}


//数据发送成功
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //NSLogo(@"发送数据成功! ");
}


- (void)threadRunloopPoint:(id)__unused object{
    NSLogo(@"%@",NSStringFromSelector(_cmd));
    @autoreleasepool {
        [[NSThread currentThread] setName:@"changzhuThread"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        //// 这里主要是监听某个 port，目的是让这个 Thread 不会回收
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}


- (void)printfstring:(NSString*)logString
{
    NSLogo(@"x : %@", logString);
}


- (void)sendLogContent2_not_finish:(NSString*)logString
{
    if(!self.thread) {
        self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadRunloopPoint:) object:nil];
        [self.thread start];
    }
    
    [self performSelector:@selector(printfstring:) onThread:self.thread withObject:logString waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
}





struct log_send_context {
    pthread_t           pid;
    pthread_mutex_t     lock;
    
    //可将缓冲区更换为无锁环形缓冲区.
    #define  LEN_BUF    (100*1024)
    char                *buf[LEN_BUF];
    unsigned long       write_offset;
    unsigned long       total_lenght;
    unsigned long       read_offset;
};
static struct log_send_context *klogcontext = NULL;

void* func_send_log(void *arg)
{
    //加锁从缓冲区中读取.
    
    struct sockaddr_in server_addr;
    server_addr.sin_len = sizeof(struct sockaddr_in);
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(SERVER_PORT);
    server_addr.sin_addr.s_addr = inet_addr(SERVER_ADDR);
    bzero(&(server_addr.sin_zero),8);
    
    int server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket == -1) {
        perror("socket error");
        return NULL;
    }
    
    char reply_msg[1024];
    printf(" start connect.\n");
    
    if (connect(server_socket, (struct sockaddr *)&server_addr, sizeof(struct sockaddr_in))==0)     {
        //connect 成功之后，其实系统将你创建的socket绑定到一个系统分配的端口上，且其为全相关，包含服务器端的信息，可以用来和服务器端进行通信。
        while (1) {
            /*
             bzero(recv_msg, 1024);
             bzero(reply_msg, 1024);
             long byte_num = recv(server_socket,recv_msg,1024,0);
             recv_msg[byte_num] = '\0';
             printf("server said:%s\n",recv_msg);
             */
            
            sleep(1);
            printf("prepare to send: \n");
            //scanf("%s",reply_msg);
            snprintf(reply_msg, 1024, "123");
            
            if (send(server_socket, reply_msg, 1024, 0) == -1) {
                perror("send error");
            }
        }
    }
    
    // insert code here...
    printf("#error. unexpected return.\n");
    
    return NULL;
}


- (void)sendLogContent3_not_finish:(NSString*)logString
{
    if(!klogcontext) {
        klogcontext = malloc(sizeof(*klogcontext));
        if(!klogcontext) {
            return;
        }
        memset(klogcontext, 0, sizeof(*klogcontext));
        klogcontext->write_offset = 0;
        klogcontext->total_lenght = LEN_BUF;
        klogcontext->read_offset = 0;
        int ret = pthread_create(&klogcontext->pid, NULL, func_send_log, klogcontext);
        if(0 == ret) {
            pthread_detach(klogcontext->pid);
        }
    }
    
    if(!klogcontext) {
        return;
    }
    
    const char* pchars = [logString UTF8String];
    if(!pchars) {
        return;
    }
    
    size_t len = strlen(pchars);
    if(len >= (1<<16)) {
        return;
    }
    
    if((klogcontext->write_offset + len + 10) < LEN_BUF) {
        klogcontext->write_offset = 0;
    }
    
    //写加锁.
    memcpy(klogcontext->buf + klogcontext->write_offset + 0, @"#@", 2);
    char lentohex[10];
    snprintf(lentohex, 10, "%04zx", len);
    memcpy(klogcontext->buf + klogcontext->write_offset + 2, lentohex, 4);
    memcpy(klogcontext->buf + klogcontext->write_offset + 6, lentohex, 4);
    memcpy(klogcontext->buf + klogcontext->write_offset + 10, pchars, len);
    klogcontext->write_offset += (10 + len);
}


- (void)LogContentRaw:(NSString*)content line:(long)line file:(const char*)file function:(const char*)function
{
    double interval = [FuncDefine timeIntervalCountWithRecount:false];
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendFormat:@"%60s %6ld %3.6f: %@", function, line, interval, content];
    printf("%s\n", [str UTF8String]);
    
    NSMutableDictionary *dictm = [[NSMutableDictionary alloc] init];
    [dictm setObject:content forKey:@"c"];
    [dictm setObject:[NSNumber numberWithDouble:[FuncDefine timeIntervalCountWithRecount:false]] forKey:@"v"];
    [dictm setObject:[NSValue valueWithPointer:(__bridge const void * _Nullable)([NSThread currentThread])] forKey:@"t"];
    [dictm setObject:[NSString stringWithCString:function encoding:NSUTF8StringEncoding] forKey:@"f"];
    [dictm setObject:[NSString stringWithCString:file encoding:NSUTF8StringEncoding] forKey:@"F"];
    [dictm setObject:[NSNumber numberWithLong:line] forKey:@"l"];
    NSMutableString *sendString = [[NSMutableString alloc] init];
    [sendString appendString:@"{"];
    [sendString appendFormat:@"\"c\":\"%@\", ", [NSString URLEncodedString:content]];
    [sendString appendFormat:@"\"v\":%@, ", [NSNumber numberWithDouble:[FuncDefine timeIntervalCountWithRecount:false]]];
    [sendString appendFormat:@"\"t\":\"%@\", ", [NSValue valueWithPointer:(__bridge const void * _Nullable)([NSThread currentThread])]];
    [sendString appendFormat:@"\"f\":\"%@\", ", [NSString stringWithCString:function encoding:NSUTF8StringEncoding]];
    [sendString appendFormat:@"\"F\":\"%@\", ", [NSString stringWithCString:file encoding:NSUTF8StringEncoding]];
    [sendString appendFormat:@"\"l\":%@, ", [NSNumber numberWithLong:line]];
    [sendString appendFormat:@"\"n\":%@, ", [NSNumber numberWithInteger:self.sn]];
    [sendString appendFormat:@"\"e\":1 }"];
    
    self.sn ++;
    
    if([NSThread currentThread] == [NSThread mainThread]) {
        [self sendLogContent:sendString];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendLogContent:sendString];
        });
    }
    
    //连接出问题的时候, 尝试以bsd socket的方式连接.
    static int kf = 0;
    if(kf) {
        kf = 1;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self sendLogContent3_not_finish:content];
        });
    }
}



@end



#if 0
[[NSThread currentThread] setName:@"AFNetworking"];
NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
// 这里主要是监听某个 port，目的是让这个 Thread 不会回收
[runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
#endif


#if 0
#define NSLog(FORMAT, ...) {\
NSMutableString *str = [[NSMutableString alloc] init];\
[str appendFormat:@"%60s %6d %3.6f: ", __FUNCTION__, __LINE__, [FuncDefine timeIntervalCountWithRecount:false] ];\
[str appendFormat:FORMAT, ##__VA_ARGS__];\
printf("%s\n", [str UTF8String]);\
[[NSLogn sharedNSLogn] sendLogContent:[NSString stringWithFormat:@"%@\n", str]];\
}
#endif



