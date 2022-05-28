# Ed25519 WASM Wrapper

### Description
WASM wrapper around parts of [SUPERCOP's Ed25519 implementation](https://bench.cr.yp.to/supercop.html).

### Building
Run the following commands to build this wrapper as WASM. The resulting files will be in the `dist` folder.
```
make dependencies
make wasm
```

Run the following commands to build this wrapper as asm.js. The resulting file will be in the `dist` folder.
```
make dependencies
make asmjs
```
