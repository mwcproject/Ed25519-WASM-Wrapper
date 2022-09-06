# Library parameters
NAME = "Ed25519"
VERSION = "0.0.4"
CC = "em++"
CFLAGS = -Wall -D NDEBUG -Oz -finput-charset=UTF-8 -fexec-charset=UTF-8 -funsigned-char -ffunction-sections -fdata-sections -D VERSION=$(VERSION) -I "./" -I "./supercop-20220213/crypto_sign/ed25519/ref10" -s MODULARIZE=1 --memory-init-file=0 -s ABORTING_MALLOC=0 -s ALLOW_MEMORY_GROWTH=1 --closure 1 -flto -fno-rtti -fno-exceptions -s NO_FILESYSTEM=1 -s DISABLE_EXCEPTION_CATCHING=1 -s EXPORTED_FUNCTIONS="['_malloc', '_free']" -s EXPORT_NAME="ed25519" -D CRYPTO_NAMESPACE\(x\)=x
LIBS =
SRCS = "./crypto_hash_sha512.c" "./crypto_verify_32.c" "./randombytes.c" "./main.cpp" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_0.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_1.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_add.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_cmov.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_copy.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_frombytes.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_invert.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_isnegative.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_isnonzero.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_mul.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_neg.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_pow22523.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_sq.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_sq2.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_sub.c" "./supercop-20220213/crypto_sign/ed25519/ref10/fe_tobytes.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_add.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_double_scalarmult.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_frombytes.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_madd.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_msub.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p1p1_to_p2.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p1p1_to_p3.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p2_0.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p2_dbl.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p3_0.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p3_dbl.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p3_tobytes.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p3_to_cached.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_p3_to_p2.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_precomp_0.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_scalarmult_base.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_sub.c" "./supercop-20220213/crypto_sign/ed25519/ref10/ge_tobytes.c" "./supercop-20220213/crypto_sign/ed25519/ref10/keypair.c" "./supercop-20220213/crypto_sign/ed25519/ref10/open.c" "./supercop-20220213/crypto_sign/ed25519/ref10/sc_muladd.c" "./supercop-20220213/crypto_sign/ed25519/ref10/sc_reduce.c" "./supercop-20220213/crypto_sign/ed25519/ref10/sign.c"

PROGRAM_NAME = $(subst $\",,$(NAME))

# Make WASM
wasm:
	$(CC) $(CFLAGS) -s WASM=1 -s ENVIRONMENT=web -o "./$(PROGRAM_NAME).js" $(SRCS) $(LIBS)
	cat "./main.js" >> "./$(PROGRAM_NAME).js"
	rm -rf "./dist"
	mkdir "./dist"
	mv "./$(PROGRAM_NAME).js" "./$(PROGRAM_NAME).wasm" "./dist/"

# Make asm.js
asmjs:
	$(CC) $(CFLAGS) -s WASM=0 -s ENVIRONMENT=web -o "./$(PROGRAM_NAME).js" $(SRCS) $(LIBS)
	cat "./main.js" >> "./$(PROGRAM_NAME).js"
	rm -rf "./dist"
	mkdir "./dist"
	mv "./$(PROGRAM_NAME).js" "./dist/"

# Make npm
npm:
	$(CC) $(CFLAGS) -s WASM=1 -s BINARYEN_ASYNC_COMPILATION=0 -s SINGLE_FILE=1 -o "./wasm.js" $(SRCS) $(LIBS)
	$(CC) $(CFLAGS) -s WASM=0 -s BINARYEN_ASYNC_COMPILATION=0 -s SINGLE_FILE=1 -o "./asm.js" $(SRCS) $(LIBS)
	echo "try { module[\"exports\"] = require(\"@nicolasflamel/ed25519-native\"); return;} catch(error) {} const ed25519 = (typeof WebAssembly !== \"undefined\") ? require(\"./wasm.js\") : require(\"./asm.js\");" > "./index.js"
	cat "./main.js" >> "./index.js"
	rm -rf "./dist"
	mkdir "./dist"
	mv "./index.js" "./wasm.js" "./asm.js" "./dist/"

# Make clean
clean:
	rm -rf "./$(PROGRAM_NAME).js" "./$(PROGRAM_NAME).wasm" "./index.js" "./wasm.js" "./asm.js" "./dist" "./supercop-20220213" "./supercop-20220213.tar.xz"

# Make dependencies
dependencies:
	wget "https://bench.cr.yp.to/supercop/supercop-20220213.tar.xz"
	unxz < "./supercop-20220213.tar.xz" | tar -xf -
	rm "./supercop-20220213.tar.xz"
	sed -i 's/static const unsigned char zero\[32\];/static const unsigned char zero[32] = {0};/g' "./supercop-20220213/crypto_sign/ed25519/ref10/fe_isnonzero.c"
