import React, { useState } from 'react';
import {
  CModal,
  CModalHeader,
  CModalTitle,
  CModalBody,
  CModalFooter,
  CButton,
  CAlert,
  CSpinner,
  CRow,
  CCol,
} from '@coreui/react-pro';
import { Client } from 'src/db/database';

interface SendInviteModalProps {
  showModal: boolean;
  setShowModal: (show: boolean) => void;
  client: Client | undefined;
}

interface SendInviteEmailRequest {
  clientName: string;
  clientEmail: string;
  cid: string;
}

interface SendInviteEmailResponse {
  success: boolean;
  message: string;
  messageId?: string;
  error?: string;
}

const SendInviteModal: React.FC<SendInviteModalProps> = ({
  showModal,
  setShowModal,
  client,
}) => {
  const [isLoading, setIsLoading] = useState(false);
  const [alertMessage, setAlertMessage] = useState<string>('');
  const [alertColor, setAlertColor] = useState<'success' | 'danger'>('success');

  const handleSendInvite = async () => {
    if (!client) {
      setAlertMessage('No client selected');
      setAlertColor('danger');
      return;
    }

    // Only use initEmail as requested
    if (!client.initEmail) {
      setAlertMessage('Client must have an initial email address to send an invite');
      setAlertColor('danger');
      return;
    }

    setIsLoading(true);
    setAlertMessage('');

    try {
      const clientName = client.firstName || 'Valued Client';

      // Call the Firebase Cloud Function directly via HTTP
      const response = await fetch('https://us-central1-armm-app.cloudfunctions.net/sendInviteEmail', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          clientName: clientName,
          clientEmail: client.initEmail,
          cid: client.cid
        })
      });

      const result: SendInviteEmailResponse = await response.json();

      if (result.success) {
        setAlertMessage(`Invite email sent successfully to ${client.initEmail}`);
        setAlertColor('success');
        
        // Auto-close modal after 3 seconds on success
        setTimeout(() => {
          setShowModal(false);
        }, 3000);
      } else {
        setAlertMessage(result.error || result.message || 'Failed to send invite email');
        setAlertColor('danger');
      }
    } catch (error) {
      console.error('Error sending invite email:', error);
      setAlertMessage('Failed to send invite email. Please check your connection and try again.');
      setAlertColor('danger');
    } finally {
      setIsLoading(false);
    }
  };

  const handleClose = () => {
    setShowModal(false);
    setAlertMessage('');
    setIsLoading(false);
  };

  if (!client) {
    return null;
  }

  const clientName = `${client.firstName} ${client.lastName}`.trim();
  const emailToUse = client.initEmail;

  return (
    <CModal
      visible={showModal}
      onClose={handleClose}
      alignment="center"
      backdrop="static"
    >
      <CModalHeader>
        <CModalTitle>Send App Invitation</CModalTitle>
      </CModalHeader>
      <CModalBody>
        {alertMessage && (
          <CAlert color={alertColor} className="mb-3">
            {alertMessage}
          </CAlert>
        )}
        
        <div className="mb-3">
          <h6>Client Information:</h6>
          <CRow className="mb-2">
            <CCol sm="4"><strong>Name:</strong></CCol>
            <CCol sm="8">{clientName || 'N/A'}</CCol>
          </CRow>
          <CRow className="mb-2">
            <CCol sm="4"><strong>CID:</strong></CCol>
            <CCol sm="8">{client.cid}</CCol>
          </CRow>
          <CRow className="mb-2">
            <CCol sm="4"><strong>Email:</strong></CCol>
            <CCol sm="8">{emailToUse || 'No email address'}</CCol>
          </CRow>
          <CRow className="mb-2">
            <CCol sm="4"><strong>Linked:</strong></CCol>
            <CCol sm="8">{client.linked ? 'Yes' : 'No'}</CCol>
          </CRow>
        </div>

        {!emailToUse && (
          <CAlert color="warning">
            This client does not have an email address. Please add an email address before sending an invite.
          </CAlert>
        )}

        {client.linked && (
          <CAlert color="info">
            This client is already linked to the app. They may already have access.
          </CAlert>
        )}

        <p className="text-muted">
          An invitation email will be sent to the client with instructions on how to download 
          and set up the ARMM Group mobile app using their Client ID (CID).
        </p>
      </CModalBody>
      <CModalFooter>
        <CButton
          color="secondary"
          onClick={handleClose}
          disabled={isLoading}
        >
          Cancel
        </CButton>
        <CButton
          color="primary"
          onClick={handleSendInvite}
          disabled={isLoading || !emailToUse}
        >
          {isLoading ? (
            <>
              <CSpinner size="sm" className="me-2" />
              Sending...
            </>
          ) : (
            'Send Invite'
          )}
        </CButton>
      </CModalFooter>
    </CModal>
  );
};

export default SendInviteModal;
