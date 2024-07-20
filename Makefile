# Library parameters
NAME = "Ed25519"
CC = "em++"
CFLAGS = -Wall -D NDEBUG -Oz -finput-charset=UTF-8 -fexec-charset=UTF-8 -funsigned-char -ffunction-sections -fdata-sections -I "./Ed25519-NPM-Package-master/" -I "./supercop-20220213/crypto_sign/ed25519/ref10/" -s MODULARIZE=1 --memory-init-file=0 -s ABORTING_MALLOC=0 -s ALLOW_MEMORY_GROWTH=1 --closure 1 -flto -fno-rtti -fno-exceptions -s NO_FILESYSTEM=1 -s DISABLE_EXCEPTION_CATCHING=1 -s EXPORTED_FUNCTIONS="['_malloc', '_free']" -s EXPORT_NAME="ed25519" -D CRYPTO_NAMESPACE\(x\)=x
LIBS =
SRCS = "./Ed25519-NPM-Package-master/crypto_hash_sha512.c" "./Ed25519-NPM-Package-master/crypto_verify_32.c" "./Ed25519-NPM-Package-master/randombytes.c" "./Ed25519-NPM-Package-master/main.cpp" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_0.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_1.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_add.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_cmov.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_copy.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_frombytes.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_invert.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_isnegative.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_isnonzero.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_mul.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_neg.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_pow22523.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_sq.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_sq2.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_sub.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_tobytes.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_add.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_double_scalarmult.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_frombytes.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_madd.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_msub.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p1p1_to_p2.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p1p1_to_p3.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p2_0.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p2_dbl.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p3_0.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p3_dbl.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p3_tobytes.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p3_to_cached.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p3_to_p2.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_precomp_0.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_scalarmult_base.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_sub.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_tobytes.c" "./supercop-20220213/crypto_sign/ed25519/ref10/keypair.c" "./supercop-20220213/crypto_sign/ed25519/ref10/open.c" "./supercop-20220213/crypto_sign/ed25519/ref10/sc_muladd.c" "./supercop-20220213/crypto_sign/ed25519/ref10/sc_reduce.c" "./supercop-20220213/crypto_sign/ed25519/ref10/sign.c"

PROGRAM_NAME = $(subst $\",,$(NAME))

# Make WASM
wasm:
	rm -rf "./dist"
	mkdir "./dist"
	$(CC) $(CFLAGS) -s WASM=1 -s ENVIRONMENT=web -o "./dist/$(PROGRAM_NAME).js" $(SRCS) $(LIBS)
	cat "./main.js" >> "./dist/$(PROGRAM_NAME).js"

# Make asm.js
asmjs:
	rm -rf "./dist"
	mkdir "./dist"
	$(CC) $(CFLAGS) -s WASM=0 -s ENVIRONMENT=web -o "./dist/$(PROGRAM_NAME).js" $(SRCS) $(LIBS)
	cat "./main.js" >> "./dist/$(PROGRAM_NAME).js"

# Make npm
npm:
	rm -rf "./dist"
	mkdir "./dist"
	$(CC) $(CFLAGS) -s WASM=1 -s BINARYEN_ASYNC_COMPILATION=0 -s SINGLE_FILE=1 -o "./dist/wasm.js" $(SRCS) $(LIBS)
	$(CC) $(CFLAGS) -s WASM=0 -s BINARYEN_ASYNC_COMPILATION=0 -s SINGLE_FILE=1 -o "./dist/asm.js" $(SRCS) $(LIBS)
	echo "\"use strict\"; const ed25519 = (typeof WebAssembly !== \"undefined\") ? require(\"./wasm.js\") : require(\"./asm.js\");" > "./dist/index.js"
	cat "./main.js" >> "./dist/index.js"

# Make clean
clean:
	rm -rf "./supercop-20220213.tar.xz" "./supercop-20220213" "./master.zip" "./Ed25519-NPM-Package-master" "./dist"

# Make dependencies
dependencies:
	wget "https://bench.cr.yp.to/supercop/supercop-20220213.tar.xz"
	unxz < "./supercop-20220213.tar.xz" | tar -xf -
	rm "./supercop-20220213.tar.xz"
	sed -i 's/static const unsigned char zero\[32\];/static const unsigned char zero[32] = {0};/g' "./supercop-20220213/crypto_sign/ed25519/ref10/fe_isnonzero.c"
	wget "https://github.com/mwcproject/Ed25519-NPM-Package/archive/master.zip"
	unzip "./master.zip"
	rm "./master.zip"
