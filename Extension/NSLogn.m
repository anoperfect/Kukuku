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
#include <stdio.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
@interface NSLogn ()<AsyncSocketDelegate>

@property (nonatomic, strong) AsyncSocket *socket;
@property (nonatomic, strong) NSThread *thread;

@end

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
        [self init1];
    }
    return self;
}


- (void)sendLogContent:(NSString *)logString
{
    [self sendLogContent1:logString];
}


- (void)init1
{
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    NSError *err = nil;
    BOOL bconnect = [self.socket connectToHost:@"192.168.1.4" onPort:12346 error:&err];
    if(bconnect) {
        NSLog(@"&&&&&&connected to.");
    }
    else {
        NSLog(@"&&&&&&connected failed : %@.", err);
    }
}


-(void)sendLogContent1:(NSString*)logString
{
    NSData *data = [logString dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"&&&&&&data : %@", data);
    [self.socket writeData:data withTimeout:-1 tag:0];
}


-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"&&&&&&成功连接服务端：%@", host);
    
    //发送数据给服务端
    NSString *message = @" 服务器，你好 ！ ";
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [sock writeData:data withTimeout:-1 tag:100]; //发送数据
}


//数据发送成功
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"&&&&&&发送数据成功! ");
}


- (void)threadRunloopPoint:(id)__unused object{
    NSLog(@"%@",NSStringFromSelector(_cmd));
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
    NSLog(@"x : %@", logString);
}


- (void)sendLogContent2_not_finish:(NSString*)logString
{
    if(!self.thread) {
        self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadRunloopPoint:) object:nil];
        [self.thread start];
    }
    
//    [self performSelector:<#(nonnull SEL)#> onThread:<#(nonnull NSThread *)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#> modes:<#(nullable NSArray<NSString *> *)#>]
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
    server_addr.sin_port = htons(12346);
    server_addr.sin_addr.s_addr = inet_addr("192.168.1.4");
    bzero(&(server_addr.sin_zero),8);
    
    int server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket == -1) {
        perror("socket error");
        return NULL;
    }
    
    char reply_msg[1024];
    printf("------------------- start connect.\n");
    
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
           




@end



#if 0
[[NSThread currentThread] setName:@"AFNetworking"];
NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
// 这里主要是监听某个 port，目的是让这个 Thread 不会回收
[runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
#endif



