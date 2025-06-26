;; Integrity Protection Contract
;; Protects document integrity through hashing

(define-map document-hashes (buff 32) {creator: principal, created-at: uint, verified: bool})
(define-map document-metadata (buff 32) {filename: (string-ascii 100), size: uint})

;; Store document hash
(define-public (store-document-hash (doc-hash (buff 32)) (filename (string-ascii 100)) (size uint))
  (begin
    (asserts! (is-none (map-get? document-hashes doc-hash)) (err u200))
    (map-set document-hashes doc-hash {creator: tx-sender, created-at: block-height, verified: true})
    (map-set document-metadata doc-hash {filename: filename, size: size})
    (ok doc-hash)
  )
)

;; Verify document integrity
(define-read-only (verify-document-integrity (doc-hash (buff 32)))
  (match (map-get? document-hashes doc-hash)
    document-info (ok (get verified document-info))
    (err u201)
  )
)

;; Get document info
(define-read-only (get-document-info (doc-hash (buff 32)))
  (map-get? document-hashes doc-hash)
)

;; Get document metadata
(define-read-only (get-document-metadata (doc-hash (buff 32)))
  (map-get? document-metadata doc-hash)
)

;; Check if document exists
(define-read-only (document-exists (doc-hash (buff 32)))
  (is-some (map-get? document-hashes doc-hash))
)
