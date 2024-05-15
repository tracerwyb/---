 //#include "mainwindow.h"
#include "network.h"
#include "client.h"
#include <QApplication>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <iostream>
#include <string.h>


int main(int argc, char *argv[])
{

    Network network;
    Client client;
    network.createSocket();

    while (1) {
        int choice;
        int retval;
        retval=network.Select();
        std::cout<<"retval:"<<retval<<std::endl;
        if(retval==1){
            network.reciveTextMessage();
        }
        std::cout<<"If you want send msg,please input 1"<<std::endl;
        std::cin>>choice;
        if(choice==1){
            char* buf=client.Messagedata();
            std::cout<<"main():"<<buf;
            qDebug()<<"buf len"<<strlen(buf);
            network.sendTextMessage(buf,strlen(buf));
        }
    }

    network.closeSocket();
}

