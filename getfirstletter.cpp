#include "getfirstletter.h"

GetFirstLetter::GetFirstLetter() {}

char GetFirstLetter::getFirstWord(const QString &str)
{
    QByteArray bArr = str.toLocal8Bit();
    const char *p = bArr.data();
    uint8_t firstByte = *p;
    if (firstByte < 128) {
        return firstByte;
    }

    uint8_t secondByte = *(p + 1);
    uint16_t word = 0;
    word = firstByte << 8;
    word |= secondByte;

    if (word >= 0xB0A1 && word < 0xB0C4)
        return 'A';
    if (word >= 0XB0C5 && word < 0XB2C0)
        return 'B';
    if (word >= 0xB2C1 && word < 0xB4ED)
        return 'C';
    if (word >= 0xB4EE && word < 0xB6E9)
        return 'D';
    if (word >= 0xB6EA && word < 0xB7A1)
        return 'E';
    if (word >= 0xB7A2 && word < 0xB8c0)
        return 'F';
    if (word >= 0xB8C1 && word < 0xB9FD)
        return 'G';
    if (word >= 0xB9FE && word < 0xBBF6)
        return 'H';
    if (word >= 0xBBF7 && word < 0xBFA5)
        return 'J';
    if (word >= 0xBFA6 && word < 0xC0AB)
        return 'K';
    if (word >= 0xC0AC && word < 0xC2E7)
        return 'L';
    if (word >= 0xC2E8 && word < 0xC4C2)
        return 'M';
    if (word >= 0xC4C3 && word < 0xC5B5)
        return 'N';
    if (word >= 0xC5B6 && word < 0xC5BD)
        return 'O';
    if (word >= 0xC5BE && word < 0xC6D9)
        return 'P';
    if (word >= 0xC6DA && word < 0xC8BA)
        return 'Q';
    if (word >= 0xC8BB && word < 0xC8F5)
        return 'R';
    if (word >= 0xC8F6 && word < 0xCBF0)
        return 'S';
    if (word >= 0xCBFA && word < 0xCDD9)
        return 'T';
    if (word >= 0xCDDA && word < 0xCEF3)
        return 'W';
    if (word >= 0xCEF4 && word < 0xD188)
        return 'X';
    if (word >= 0xD1B9 && word < 0xD4D0)
        return 'Y';
    if (word >= 0xD4D1 && word < 0xD7F9)
        return 'Z';
    return '#';
}

char GetFirstLetter::FirstLetter(const QString &str)
{
    int ucHigh, ucLow;
    int nCode;
    QByteArray bArr = str.toLocal8Bit();
    const char *p = bArr.data();
    uint8_t firstByte = *p;
    ucHigh = (int) (p[0] & 0xFF);
    ucLow = (int) (p[1] & 0xFF);
    if (ucHigh < 0xa1 || ucLow < 0xa1) {
        return firstByte;
    }
    nCode = (ucHigh - 0xa0) * 100 + ucLow - 0xa0;

    if (nCode >= 1601 && nCode < 1637)
        return 'A';
    if (nCode >= 1637 && nCode < 1833)
        return 'B';
    if (nCode >= 1833 && nCode < 2078)
        return 'C';
    if (nCode >= 2078 && nCode < 2274)
        return 'D';
    if (nCode >= 2274 && nCode < 2302)
        return 'E';
    if (nCode >= 2302 && nCode < 2433)
        return 'F';
    if (nCode >= 2433 && nCode < 2594)
        return 'G';
    if (nCode >= 2594 && nCode < 2787)
        return 'H';
    if (nCode >= 2787 && nCode < 3106)
        return 'J';
    if (nCode >= 3106 && nCode < 3212)
        return 'K';
    if (nCode >= 3212 && nCode < 3472)
        return 'L';
    if (nCode >= 3472 && nCode < 3635)
        return 'M';
    if (nCode >= 3635 && nCode < 3722)
        return 'N';
    if (nCode >= 3722 && nCode < 3730)
        return 'O';
    if (nCode >= 3730 && nCode < 3858)
        return 'P';
    if (nCode >= 3858 && nCode < 4027)
        return 'Q';
    if (nCode >= 4027 && nCode < 4086)
        return 'R';
    if (nCode >= 4086 && nCode < 4390)
        return 'S';
    if (nCode >= 4390 && nCode < 4558)
        return 'T';
    if (nCode >= 4558 && nCode < 4684)
        return 'W';
    if (nCode >= 4684 && nCode < 4925)
        return 'X';
    if (nCode >= 4925 && nCode < 5249)
        return 'Y';
    if (nCode >= 5249 && nCode < 5590)
        return 'Z';
    return '#';
}
