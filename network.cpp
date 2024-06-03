#include "network.h"
#include <string.h>
#include <QApplication>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <unistd.h>

#define IPADDR "192.168.101.210" //10.253.209.148" //"10.253.172.131"
#define PORT 9879
Network::Network() {}

void Network::createSocket()
{
    m_listenfd = socket(AF_INET,SOCK_STREAM,0);
    struct sockaddr_in servaddr;
    bzero(&servaddr,sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(PORT);
    std::string ip=IPADDR;       //
    char * ipaddr=ip.data();
    inet_pton(AF_INET,ipaddr,&servaddr.sin_addr);

    if(connect(m_listenfd,(struct sockaddr *)&servaddr,sizeof(servaddr))<0){
        qDebug()<<"Create socket failed. Errorn info";
    }
    else {
        qDebug()<<"connect succeed!";
        qDebug()<<m_listenfd;
    }
}

void Network::sendTextMessage(char* sendmessage,int size)
{
    write(m_listenfd,&size,sizeof(size));
    int offset=0;
    int n=0;
    while(size>0){
        n=write(m_listenfd,sendmessage+offset,size);
        if(n<0){
            qDebug()<<"write erro!";
            break;
        }
        offset+=n;
        size=size-n;
    }
}

int Network::reciveTextMessage(char* recivemessage)
{
    int size=0;
    int result=read(m_listenfd,&size,sizeof(size));
    if(result<=0){
        return -1;
    }
    qDebug()<<"size :"<<size;
    //char recivemessage[1024]="";
    int n=0;
    int posx=0;
    while((size-n)>0 ){
        n=read(m_listenfd,recivemessage+posx,size); //size=size-n
        posx+=n;
    }
    qDebug()<<"mesg:"<<recivemessage;
    return 0;
}

void Network::closeSocket()
{
    close(m_listenfd);
}

int Network::Select()
{
    fd_set readfds;
    struct timeval tv;
    int retval;

    FD_ZERO(&readfds);
    FD_SET(m_listenfd,&readfds);

    tv.tv_sec=1;  //seconds
    tv.tv_usec=0; //misroseconds

    retval = select(m_listenfd+1,&readfds,NULL,NULL,&tv);
    if(retval ==1 )
        return 1;
    else {
        return 0;
    }
}


