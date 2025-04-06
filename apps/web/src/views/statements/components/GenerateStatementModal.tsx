import { CModal, CModalHeader, CModalTitle, CModalBody, CMultiSelect, CFormInput, CAlert, CModalFooter, CButton, CDateRangePicker, CInputGroup, CInputGroupText, CLoadingButton } from '@coreui/react-pro';
import { Option } from "@coreui/react-pro/dist/esm/components/multi-select/types";
import { set } from 'date-fns';
import React from 'react';
import { Client, DatabaseService } from 'src/db/database';

interface GenerateStatementModalProps {
  showModal: boolean,
  setShowModal: (show: boolean) => void,
  clientOptions: Option[],
}

const GenerateStatementModal: React.FC<GenerateStatementModalProps> = ({showModal, setShowModal, clientOptions}) => {
  const db = new DatabaseService();  
  const [currentClient, setCurrentClient] = React.useState<Client | null>(null);
  const [startDate, setStartDate] = React.useState<Date | null>(null);
  const [endDate, setEndDate] = React.useState<Date | null>(null);
  const [isLoading, setIsLoading] = React.useState(false);
  return (
    <CModal visible={showModal} onClose={() => setShowModal(false)} size='lg' alignment="center">
      <CModalHeader closeButton>
        <CModalTitle>Generate Statement</CModalTitle>
      </CModalHeader>
      <CModalBody>
        <>
          <CInputGroup>
            <CMultiSelect
              id="client"
              className="mb-3a custom-multiselect-dropdown"
              options={clientOptions}
              defaultValue={currentClient?.cid}
              placeholder="Select Client"
              selectAll={false}
              multiple={false}
              allowCreateOptions={false}
              onChange={async (selectedValue) => {
                if (selectedValue.length === 0) {
                  return;
                }
                
                const cid = selectedValue.map(selected => selected.value as string)[0];
                const client = selectedValue.map(selected => selected.label as string)[0];
                
                const newClient = await db.getClient(cid);
                if (newClient) {
                  setCurrentClient(newClient);
                }
              }}
            />
            <CInputGroupText>Start Date</CInputGroupText>
            <CFormInput type='date' onChange={
              (e) => {
                const date = new Date(e.target.value);
                setStartDate(date);
              }
            }/>
            <CInputGroupText>End Date</CInputGroupText>
            <CFormInput type='date' onChange={
              (e) => {
                const date = new Date(e.target.value);
                setEndDate(date);
              }
            }/>
            </CInputGroup>
            {startDate && endDate && startDate > endDate && (
              <div className="text-danger mt-2">
                Start date must be before end date.
              </div>
            )}
        </>
      </CModalBody>
      <CModalFooter>
        <CButton color="secondary" onClick={() => setShowModal(false)} >
          Cancel
        </CButton>
        <CLoadingButton
          color="primary" 
          onClick={
            async () => {
              const db = new DatabaseService();
              setIsLoading(true);
              await db.generateStatementPDF(currentClient!, startDate!, endDate!);
              setIsLoading(false);
              setShowModal(false);
            }
          }
          loading={isLoading}
          disabled={!currentClient || !startDate || !endDate || startDate > endDate}  // Disable button if any of the fields are empty
        >
          Generate
        </CLoadingButton>
      </CModalFooter>
    </CModal>
  );
};

export default GenerateStatementModal;