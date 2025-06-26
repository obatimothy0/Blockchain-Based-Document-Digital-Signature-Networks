# Blockchain-Based Document Digital Signature Networks

A comprehensive blockchain-based digital signature system built on Clarity smart contracts, providing secure, verifiable, and auditable document signing capabilities.

## Architecture

### Core Components

#### 1. Signature Authority Contract
Manages and validates signature authorities who can create digital signatures.

**Key Functions:**
- Register new signature authorities
- Validate authority credentials
- Revoke authority permissions

#### 2. Signature Creation Contract
Handles the creation of digital signatures for documents.

**Key Functions:**
- Create digital signatures
- Link signatures to documents
- Validate signature requests

#### 3. Verification Management Contract
Manages the verification process for digital signatures.

**Key Functions:**
- Verify signature authenticity
- Check signature validity
- Manage verification status

#### 4. Integrity Protection Contract
Protects document integrity through cryptographic hashing.

**Key Functions:**
- Generate document hashes
- Verify document integrity
- Track document modifications

#### 5. Audit Trail Contract
Maintains comprehensive audit trails for all signature activities.

**Key Functions:**
- Log signature events
- Track verification activities
- Generate audit reports

## Usage

### Deploying Contracts

Deploy contracts in the following order:
1. signature-authority.clar
2. integrity-protection.clar
3. signature-creation.clar
4. verification-management.clar
5. audit-trail.clar

### Creating a Digital Signature

1. Register as a signature authority
2. Submit document hash for integrity protection
3. Create digital signature
4. Verify signature through verification management
5. Audit trail automatically logs all activities

## Testing

Run tests using Vitest:

\`\`\`bash
npm test
\`\`\`

Tests cover:
- Authority validation
- Signature creation and verification
- Document integrity protection
- Audit trail functionality
- Error handling and edge cases

## Security Features

- **Authority-based Access Control**: Only approved authorities can create signatures
- **Document Privacy**: Only document hashes are stored on-chain
- **Immutable Records**: All signature data is permanently recorded
- **Comprehensive Auditing**: Full audit trail for compliance requirements
- **Integrity Verification**: Cryptographic protection against document tampering

## Contract Interactions

The contracts work together to provide a complete signature ecosystem:

- Authority contract validates who can sign
- Integrity contract ensures document hasn't been tampered with
- Creation contract generates the actual signature
- Verification contract confirms signature validity
- Audit contract logs all activities for compliance

## Development

### Prerequisites
- Clarity development environment
- Vitest for testing
- Node.js runtime

### Local Development
1. Clone the repository
2. Install dependencies: \`npm install\`
3. Run tests: \`npm test\`
4. Deploy contracts to local testnet

## License

MIT License - see LICENSE file for details
\`\`\`

Now let's create the Clarity smart contracts:

```clarity file="contracts/signature-authority.clar"
;; Signature Authority Contract
;; Manages signature authorities and their permissions

(define-map authorities principal bool)
(define-map authority-details principal {name: (string-ascii 50), registered-at: uint})
(define-data-var contract-owner principal tx-sender)

;; Register a new signature authority
(define-public (register-authority (authority principal) (name (string-ascii 50)))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err u100))
    (map-set authorities authority true)
    (map-set authority-details authority {name: name, registered-at: block-height})
    (ok true)
  )
)

;; Check if principal is a valid authority
(define-read-only (is-valid-authority (authority principal))
  (default-to false (map-get? authorities authority))
)

;; Get authority details
(define-read-only (get-authority-details (authority principal))
  (map-get? authority-details authority)
)

;; Revoke authority
(define-public (revoke-authority (authority principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err u101))
    (map-delete authorities authority)
    (ok true)
  )
)

;; Get contract owner
(define-read-only (get-contract-owner)
  (var-get contract-owner)
)
