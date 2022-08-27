// Use strict
"use strict";


// Classes

// Ed25519 class
class Ed25519 {

	// Public
	
		// Initialize
		static initialize() {
		
			// Set instance to invalid
			Ed25519.instance = Ed25519.INVALID;
		
			// Return promise
			return new Promise(function(resolve, reject) {
		
				// Set settings
				var settings = {
				
					// On abort
					"onAbort": function(error) {
					
						// Prevent on abort from being called again
						delete settings["onAbort"];
						
						// Reject error
						reject("Failed to download resource");
					}
				};
				
				// Create Ed25519 instance
				ed25519(settings).then(function(instance) {
				
					// Prevent on abort from being called
					delete settings["onAbort"];
				
					// Set instance
					Ed25519.instance = instance;
					
					// Resolve
					resolve();
				});
			});
		}
		
		// Public key from secret key
		static publicKeyFromSecretKey(secretKey) {
		
			// Check if instance doesn't exist
			if(typeof Ed25519.instance === "undefined")
			
				// Set instance
				Ed25519.instance = ed25519();
		
			// Check if instance is invalid
			if(Ed25519.instance === Ed25519.INVALID)
			
				// Return operation failed
				return Ed25519.OPERATION_FAILED;
			
			// Initialize public key to size of public key
			var publicKey = new Uint8Array(Ed25519.instance._publicKeySize());
			
			// Allocate and fill memory
			var publicKeyBuffer = Ed25519.instance._malloc(publicKey["length"] * publicKey["BYTES_PER_ELEMENT"]);
			
			var secretKeyBuffer = Ed25519.instance._malloc(secretKey["length"] * secretKey["BYTES_PER_ELEMENT"]);
			Ed25519.instance["HEAPU8"].set(secretKey, secretKeyBuffer / secretKey["BYTES_PER_ELEMENT"]);
			
			// Check if getting public key from secret key failed
			if(Ed25519.instance._publicKeyFromSecretKey(publicKeyBuffer, secretKeyBuffer, secretKey["length"] * secretKey["BYTES_PER_ELEMENT"]) === Ed25519.C_FALSE) {
			
				// Clear memory
				Ed25519.instance["HEAPU8"].fill(0, publicKeyBuffer / publicKey["BYTES_PER_ELEMENT"], publicKeyBuffer / publicKey["BYTES_PER_ELEMENT"] + publicKey["length"]);
				Ed25519.instance["HEAPU8"].fill(0, secretKeyBuffer / secretKey["BYTES_PER_ELEMENT"], secretKeyBuffer / secretKey["BYTES_PER_ELEMENT"] + secretKey["length"]);
				
				// Free memory
				Ed25519.instance._free(publicKeyBuffer);
				Ed25519.instance._free(secretKeyBuffer);
			
				// Return operation failed
				return Ed25519.OPERATION_FAILED;
			}
			
			// Get public key
			publicKey = new Uint8Array(Ed25519.instance["HEAPU8"].subarray(publicKeyBuffer, publicKeyBuffer + publicKey["length"]));
			
			// Clear memory
			Ed25519.instance["HEAPU8"].fill(0, publicKeyBuffer / publicKey["BYTES_PER_ELEMENT"], publicKeyBuffer / publicKey["BYTES_PER_ELEMENT"] + publicKey["length"]);
			Ed25519.instance["HEAPU8"].fill(0, secretKeyBuffer / secretKey["BYTES_PER_ELEMENT"], secretKeyBuffer / secretKey["BYTES_PER_ELEMENT"] + secretKey["length"]);
			
			// Free memory
			Ed25519.instance._free(publicKeyBuffer);
			Ed25519.instance._free(secretKeyBuffer);
			
			// Return public key
			return publicKey;
		}
		
		// Sign
		static sign(message, secretKey) {
		
			// Check if instance doesn't exist
			if(typeof Ed25519.instance === "undefined")
			
				// Set instance
				Ed25519.instance = ed25519();
		
			// Check if instance is invalid
			if(Ed25519.instance === Ed25519.INVALID)
			
				// Return operation failed
				return Ed25519.OPERATION_FAILED;
			
			// Initialize signature to size of signature
			var signature = new Uint8Array(Ed25519.instance._signatureSize());
			
			// Allocate and fill memory
			var signatureBuffer = Ed25519.instance._malloc(signature["length"] * signature["BYTES_PER_ELEMENT"]);
			
			var messageBuffer = Ed25519.instance._malloc(message["length"] * message["BYTES_PER_ELEMENT"]);
			Ed25519.instance["HEAPU8"].set(message, messageBuffer / message["BYTES_PER_ELEMENT"]);
			
			var secretKeyBuffer = Ed25519.instance._malloc(secretKey["length"] * secretKey["BYTES_PER_ELEMENT"]);
			Ed25519.instance["HEAPU8"].set(secretKey, secretKeyBuffer / secretKey["BYTES_PER_ELEMENT"]);
			
			// Check if signing message failed
			if(Ed25519.instance._sign(signatureBuffer, messageBuffer, message["length"] * message["BYTES_PER_ELEMENT"], secretKeyBuffer, secretKey["length"] * secretKey["BYTES_PER_ELEMENT"]) === Ed25519.C_FALSE) {
			
				// Clear memory
				Ed25519.instance["HEAPU8"].fill(0, signatureBuffer / signature["BYTES_PER_ELEMENT"], signatureBuffer / signature["BYTES_PER_ELEMENT"] + signature["length"]);
				Ed25519.instance["HEAPU8"].fill(0, messageBuffer / message["BYTES_PER_ELEMENT"], messageBuffer / message["BYTES_PER_ELEMENT"] + message["length"]);
				Ed25519.instance["HEAPU8"].fill(0, secretKeyBuffer / secretKey["BYTES_PER_ELEMENT"], secretKeyBuffer / secretKey["BYTES_PER_ELEMENT"] + secretKey["length"]);
				
				// Free memory
				Ed25519.instance._free(signatureBuffer);
				Ed25519.instance._free(messageBuffer);
				Ed25519.instance._free(secretKeyBuffer);
			
				// Return operation failed
				return Ed25519.OPERATION_FAILED;
			}
			
			// Get signature
			signature = new Uint8Array(Ed25519.instance["HEAPU8"].subarray(signatureBuffer, signatureBuffer + signature["length"]));
			
			// Clear memory
			Ed25519.instance["HEAPU8"].fill(0, signatureBuffer / signature["BYTES_PER_ELEMENT"], signatureBuffer / signature["BYTES_PER_ELEMENT"] + signature["length"]);
			Ed25519.instance["HEAPU8"].fill(0, messageBuffer / message["BYTES_PER_ELEMENT"], messageBuffer / message["BYTES_PER_ELEMENT"] + message["length"]);
			Ed25519.instance["HEAPU8"].fill(0, secretKeyBuffer / secretKey["BYTES_PER_ELEMENT"], secretKeyBuffer / secretKey["BYTES_PER_ELEMENT"] + secretKey["length"]);
			
			// Free memory
			Ed25519.instance._free(signatureBuffer);
			Ed25519.instance._free(messageBuffer);
			Ed25519.instance._free(secretKeyBuffer);
			
			// Return signature
			return signature;
		}
		
		// Verify
		static verify(message, signature, publicKey) {
		
			// Check if instance doesn't exist
			if(typeof Ed25519.instance === "undefined")
			
				// Set instance
				Ed25519.instance = ed25519();
		
			// Check if instance is invalid
			if(Ed25519.instance === Ed25519.INVALID)
			
				// Return operation failed
				return Ed25519.OPERATION_FAILED;
			
			// Allocate and fill memory
			var messageBuffer = Ed25519.instance._malloc(message["length"] * message["BYTES_PER_ELEMENT"]);
			Ed25519.instance["HEAPU8"].set(message, messageBuffer / message["BYTES_PER_ELEMENT"]);
			
			var signatureBuffer = Ed25519.instance._malloc(signature["length"] * signature["BYTES_PER_ELEMENT"]);
			Ed25519.instance["HEAPU8"].set(signature, signatureBuffer / signature["BYTES_PER_ELEMENT"]);
			
			var publicKeyBuffer = Ed25519.instance._malloc(publicKey["length"] * publicKey["BYTES_PER_ELEMENT"]);
			Ed25519.instance["HEAPU8"].set(publicKey, publicKeyBuffer / publicKey["BYTES_PER_ELEMENT"]);
			
			// Check if performing verify failed
			if(Ed25519.instance._verify(messageBuffer, message["length"] * message["BYTES_PER_ELEMENT"], signatureBuffer, signature["length"] * signature["BYTES_PER_ELEMENT"], publicKeyBuffer, publicKey["length"] * publicKey["BYTES_PER_ELEMENT"]) === Ed25519.C_FALSE) {
			
				// Clear memory
				Ed25519.instance["HEAPU8"].fill(0, messageBuffer / message["BYTES_PER_ELEMENT"], messageBuffer / message["BYTES_PER_ELEMENT"] + message["length"]);
				Ed25519.instance["HEAPU8"].fill(0, signatureBuffer / signature["BYTES_PER_ELEMENT"], signatureBuffer / signature["BYTES_PER_ELEMENT"] + signature["length"]);
				Ed25519.instance["HEAPU8"].fill(0, publicKeyBuffer / publicKey["BYTES_PER_ELEMENT"], publicKeyBuffer / publicKey["BYTES_PER_ELEMENT"] + publicKey["length"]);
				
				// Free memory
				Ed25519.instance._free(messageBuffer);
				Ed25519.instance._free(signatureBuffer);
				Ed25519.instance._free(publicKeyBuffer);
			
				// Return false
				return false;
			}
			
			// Clear memory
			Ed25519.instance["HEAPU8"].fill(0, messageBuffer / message["BYTES_PER_ELEMENT"], messageBuffer / message["BYTES_PER_ELEMENT"] + message["length"]);
			Ed25519.instance["HEAPU8"].fill(0, signatureBuffer / signature["BYTES_PER_ELEMENT"], signatureBuffer / signature["BYTES_PER_ELEMENT"] + signature["length"]);
			Ed25519.instance["HEAPU8"].fill(0, publicKeyBuffer / publicKey["BYTES_PER_ELEMENT"], publicKeyBuffer / publicKey["BYTES_PER_ELEMENT"] + publicKey["length"]);
			
			// Free memory
			Ed25519.instance._free(messageBuffer);
			Ed25519.instance._free(signatureBuffer);
			Ed25519.instance._free(publicKeyBuffer);
			
			// Return true
			return true;
		}
		
		// Operation failed
		static get OPERATION_FAILED() {
		
			// Return operation failed
			return null;
		}
	
	// Private
	
		// Invalid
		static get INVALID() {
		
			// Return invalid
			return null;
		}
		
		// C false
		static get C_FALSE() {
		
			// Return C false
			return 0;
		}
}


// Supporting fuction implementation

// Check if document doesn't exist
if(typeof document === "undefined") {

	// Create document
	var document = {};
}

// Check if module exports exists
if(typeof module === "object" && module !== null && "exports" in module === true) {

	// Exports
	module["exports"] = Ed25519;
}
