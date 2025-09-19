import React, { useState } from 'react'
import {
  CButton,
  CCard,
  CCardBody,
  CCardGroup,
  CCol,
  CContainer,
  CForm,
  CFormInput,
  CInputGroup,
  CInputGroupText,
  CRow,
  CSpinner,
  CAlert,
} from '@coreui/react-pro'
import CIcon from '@coreui/icons-react'
import { cilEnvelopeClosed, cilUser } from '@coreui/icons'
import { validateEmail } from '../../../utils/validationUtils'

const DataDeletion = () => {
  const [formData, setFormData] = useState({
    cid: '',
    email: '',
    reason: ''
  })
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [submitStatus, setSubmitStatus] = useState<{
    type: 'success' | 'error' | null
    message: string
  }>({ type: null, message: '' })
  const [errors, setErrors] = useState<{ [key: string]: string }>({})

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target
    setFormData(prev => ({ ...prev, [name]: value }))
    
    // Clear specific error when user starts typing
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }))
    }
    
    // Clear submit status on any change
    if (submitStatus.type) {
      setSubmitStatus({ type: null, message: '' })
    }
  }

  const validateForm = () => {
    const newErrors: { [key: string]: string } = {}

    if (!formData.cid.trim()) {
      newErrors.cid = 'Client ID (CID) is required'
    }

    if (!formData.email.trim()) {
      newErrors.email = 'Email address is required'
    } else if (!validateEmail(formData.email)) {
      newErrors.email = 'Please enter a valid email address'
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    
    if (!validateForm()) {
      return
    }

    setIsSubmitting(true)
    setSubmitStatus({ type: null, message: '' })

    try {
      // Call the Firebase function to send the deletion request email
      const response = await fetch('https://us-central1-armm-app.cloudfunctions.net/sendDataDeletionRequest', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          cid: formData.cid.trim(),
          email: formData.email.trim(),
          reason: formData.reason.trim() || 'No specific reason provided'
        })
      })

      const result = await response.json()

      if (response.ok && result.success) {
        setSubmitStatus({
          type: 'success',
          message: 'Your data deletion request has been submitted successfully. We will review your request and contact you within 5-7 business days.'
        })
        setFormData({ cid: '', email: '', reason: '' })
      } else {
        // Show specific error message from backend
        setSubmitStatus({
          type: 'error',
          message: result.error || 'Failed to submit request'
        })
      }
    } catch (error) {
      console.error('Error submitting deletion request:', error)
      setSubmitStatus({
        type: 'error',
        message: 'Unable to submit your request at this time. Please try again later or contact us directly at info@armmgroup.com'
      })
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <div className="bg-light min-vh-100 d-flex flex-row align-items-center">
      <CContainer>
        <CRow className="justify-content-center">
          <CCol md={8} lg={6}>
            <CCardGroup>
              <CCard className="p-4">
                <CCardBody>
                  <div className="text-center mb-4">
                    <div className="mb-3">
                      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" className="text-danger">
                        <path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2m3 0v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6h14ZM10 11v6M14 11v6" 
                              stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                      </svg>
                    </div>
                    <h1 className="text-light mb-2">Data Deletion Request</h1>
                    <p className="text-medium-emphasis">
                      Request the deletion of your account and associated data from ARMM Group systems
                    </p>
                  </div>

                  {submitStatus.type && (
                    <CAlert 
                      color={submitStatus.type === 'success' ? 'success' : 'danger'}
                      className="mb-4"
                    >
                      {submitStatus.message}
                    </CAlert>
                  )}

                  <CForm onSubmit={handleSubmit}>
                    <CInputGroup className="mb-3">
                      <CInputGroupText>
                        <CIcon icon={cilUser} />
                      </CInputGroupText>
                      <CFormInput
                        name="cid"
                        placeholder="Client ID (CID)"
                        autoComplete="username"
                        value={formData.cid}
                        onChange={handleInputChange}
                        invalid={!!errors.cid}
                        disabled={isSubmitting}
                      />
                    </CInputGroup>
                    {errors.cid && (
                      <div className="invalid-feedback d-block mb-3">
                        {errors.cid}
                      </div>
                    )}

                    <CInputGroup className="mb-3">
                      <CInputGroupText>
                        <CIcon icon={cilEnvelopeClosed} />
                      </CInputGroupText>
                      <CFormInput
                        name="email"
                        type="email"
                        placeholder="Email address associated with your account"
                        autoComplete="email"
                        value={formData.email}
                        onChange={handleInputChange}
                        invalid={!!errors.email}
                        disabled={isSubmitting}
                      />
                    </CInputGroup>
                    {errors.email && (
                      <div className="invalid-feedback d-block mb-3">
                        {errors.email}
                      </div>
                    )}
                    <div className="mb-3">
                      <small className="text-medium-emphasis">
                        Please enter the email address associated with your Client ID in our system.
                      </small>
                    </div>

                    <div className="mb-4">
                      <textarea
                        name="reason"
                        className="form-control"
                        rows={3}
                        placeholder="Reason for deletion request (optional)"
                        value={formData.reason}
                        onChange={handleInputChange}
                        disabled={isSubmitting}
                      />
                    </div>

                    <div className="mb-4">
                      <small className="text-medium-emphasis">
                        <strong>Important:</strong> This request will permanently delete your account and all associated data. 
                        This action cannot be undone. We will contact you at the provided email address to verify your identity 
                        before processing this request.
                      </small>
                    </div>

                    <CRow>
                      <CCol xs={12}>
                        <CButton
                          color="danger"
                          className="px-4 w-100"
                          type="submit"
                          disabled={isSubmitting}
                        >
                          {isSubmitting ? (
                            <>
                              <CSpinner size="sm" className="me-2" />
                              Submitting Request...
                            </>
                          ) : (
                            'Submit Deletion Request'
                          )}
                        </CButton>
                      </CCol>
                    </CRow>
                  </CForm>

                  <div className="mt-4 pt-3 border-top">
                    <div className="text-center">
                      <small className="text-medium-emphasis">
                        Need assistance? Contact us at{' '}
                        <a href="mailto:info@armmgroup.com" className="text-decoration-none">
                          info@armmgroup.com
                        </a>{' '}
                        or call{' '}
                        <a href="tel:+1-347-513-3040" className="text-decoration-none">
                          347-513-3040
                        </a>
                      </small>
                    </div>
                  </div>
                </CCardBody>
              </CCard>
            </CCardGroup>
          </CCol>
        </CRow>
      </CContainer>
    </div>
  )
}

export default DataDeletion
