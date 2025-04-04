// Statements.tsx

import React, { useEffect, useState } from 'react';
import { CContainer, CButton, CSpinner } from "@coreui/react-pro";
import { Routes, Route } from 'react-router-dom';
import ClientStatementsPage from './components/ClientStatementsPage';
import AddStatementModal from './components/AddStatementsModal';
import { DatabaseService } from 'src/db/database';
import GenerateStatementModal from './components/GenerateStatementModal';

const Statements: React.FC = () => {
  const [clients, setClients] = useState<any[]>([]);
  const [clientOptions, setClientOptions] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isAddModalVisible, setIsAddModalVisible] = useState<boolean>(false);
  const [showGenerateStatementModal, setShowGenerateStatementModal] = useState(false);

  const handleOpenModal = () => {
    setIsAddModalVisible(true);
  };

  const handleCloseModal = () => {
    setIsAddModalVisible(false);
  };

  const handleUploadSuccess = () => {
    // You can implement additional logic here, such as refreshing the statements list
    setIsAddModalVisible(false);
    // Optionally, you can trigger a refresh in ClientStatementsPage via a shared state or context
    // For simplicity, you might reload the page or implement a callback
    window.location.reload();
  };

  useEffect(() => {
      const fetchActivities = async () => {
          const db = new DatabaseService();
          const clients = await db.getClients();

          setClientOptions(
              clients!
                  .map(client => ({ value: client.cid, label: client.firstName + ' ' + client.lastName }))
                  .sort((a, b) => a.label.localeCompare(b.label))
          ); 
          setClients(clients);
          setIsLoading(false);
      };
      fetchActivities();
  }, []);

  if (isLoading) {
      return( 
          <div className="text-center">
              <CSpinner color="primary"/>
          </div>
      )
  }

  return (
    <CContainer>
      {/* Add Statement Button */}
      <div className="d-grid gap-2 py-3">
          <CButton color='secondary' onClick={() => setShowGenerateStatementModal(true)}>Generate Statement</CButton>
          <CButton color='primary' onClick={() => setIsAddModalVisible(true)}>Add Statement +</CButton>
      </div> 
      
      {/* Add Statement Modal */}
      <AddStatementModal
        visible={isAddModalVisible}
        onClose={handleCloseModal}
        onUploadSuccess={handleUploadSuccess}
      />

      {showGenerateStatementModal && 
        <GenerateStatementModal
          showModal={showGenerateStatementModal}
          setShowModal={setShowGenerateStatementModal}
          clientOptions={clientOptions}
        />
      }

      {/* Client Statements Page */}
      <ClientStatementsPage />
    </CContainer>
  );
};

export default Statements;