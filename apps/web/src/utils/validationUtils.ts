/**
 * Validation utility functions
 */

/**
 * Validates an email address format
 * @param email - Email address to validate
 * @returns true if email is valid, false otherwise
 */
export const validateEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(email.trim())
}

/**
 * Validates a CID (Client ID) format
 * @param cid - Client ID to validate
 * @returns true if CID is valid, false otherwise
 */
export const validateCID = (cid: string): boolean => {
  // CID should be non-empty and alphanumeric
  const cidRegex = /^[a-zA-Z0-9]+$/
  return cidRegex.test(cid.trim()) && cid.trim().length > 0
}
