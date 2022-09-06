#ifndef CRYPTO_SIGN_H
#define CRYPTO_SIGN_H

#include "api.h"

#define crypto_sign_SECRETKEYBYTES CRYPTO_SECRETKEYBYTES
#define crypto_sign_PUBLICKEYBYTES CRYPTO_PUBLICKEYBYTES
#define crypto_sign_BYTES CRYPTO_BYTES

extern int crypto_sign(unsigned char *, unsigned long long *, const unsigned char *, unsigned long long, const unsigned char *);
extern int crypto_sign_open(unsigned char *, unsigned long long *, const unsigned char *, unsigned long long, const unsigned char *);
extern int crypto_sign_keypair(unsigned char *, unsigned char *);

#endif
