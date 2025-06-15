// src/components/EditAssetsSection.tsx

import React, { useEffect, useState } from "react";
import {
  CContainer,
  CButton,
  CModal,
  CModalHeader,
  CModalBody,
  CModalFooter,
  CFormInput,
} from "@coreui/react-pro";
import { Client } from "../db/database";
import { AssetFormComponent } from "./AssetFormComponent";
import { cilArrowTop, cilArrowBottom, cilPlus, cilFolder, cilTrash } from "@coreui/icons"; // Import icons for reordering
import CIcon from '@coreui/icons-react';

interface EditAssetsSectionProps {
  clientState: Client;
  setClientState: (clientState: Client) => void;
  activeFund?: string;
  incrementAmount?: number;
  viewOnly?: boolean;
}

// Define keys to exclude (case-insensitive)
const excludedAssetKeys = ["total", "fund"];

export const EditAssetsSection: React.FC<EditAssetsSectionProps> = ({
  clientState,
  setClientState,
  activeFund,
  incrementAmount = 10000,
  viewOnly = false,
}) => {
  // State for managing the "Add Asset" modal
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [currentFundKey, setCurrentFundKey] = useState<string | null>(null);
  const [newAssetTitle, setNewAssetTitle] = useState<string>("");

  // New state and functions for funds
  const [isFundModalOpen, setIsFundModalOpen] = useState(false);
  const [newFundName, setNewFundName] = useState<string>("");

  const openAddFundModal = () => {
    setNewFundName("");
    setIsFundModalOpen(true);
  };

  const closeAddFundModal = () => {
    setIsFundModalOpen(false);
    setNewFundName("");
  };

  const handleAddFund = () => {
    const fundNameTrimmed = newFundName.trim();
    if (!fundNameTrimmed) {
      alert("Fund name cannot be empty.");
      return;
    }
    const newFundKey = fundNameTrimmed.toLowerCase().replace(/\s+/g, "-");
    if (clientState.assets[newFundKey]) {
      alert("A fund with this name already exists.");
      return;
    }
    const newState: typeof clientState = {
      ...clientState,
      assets: {
        ...clientState.assets,
        [newFundKey]: {}
      },
    };
    setClientState(newState);
    closeAddFundModal();
  };

  const handleDeleteFund = (fundKey: string) => {
    if (!window.confirm(`Are you sure you want to delete the fund "${fundKey}" and all its assets?`)) return;
    const newAssets = { ...clientState.assets };
    delete newAssets[fundKey];
    const newState: typeof clientState = {
      ...clientState,
      assets: newAssets,
    };
    setClientState(newState);
  };

  // Function to handle opening the modal
  const openAddAssetModal = (fundKey: string) => {
    setCurrentFundKey(fundKey);
    setNewAssetTitle("");
    setIsModalOpen(true);
  };

  // Function to handle closing the modal
  const closeAddAssetModal = () => {
    setIsModalOpen(false);
    setCurrentFundKey(null);
    setNewAssetTitle("");
  };

  // Function to handle adding a new asset
  const handleAddAsset = () => {
    if (!currentFundKey) return;

    const assetTitleTrimmed = newAssetTitle.trim();
    if (assetTitleTrimmed === "") {
      alert("Asset name cannot be empty.");
      return;
    }

    // Prevent adding 'total', 'Total', 'fund', 'Fund'
    if (excludedAssetKeys.includes(assetTitleTrimmed.toLowerCase())) {
      alert("The asset name 'total' or 'fund' is reserved and cannot be used.");
      return;
    }

    // Generate a unique type for the new asset
    const sanitizedTitle = assetTitleTrimmed.toLowerCase().replace(/\s+/g, "-");
    const newAssetType = sanitizedTitle; // Use this as the dynamic key

    // Check for duplicates
    const fundAssets = clientState.assets[currentFundKey] || {};
    const duplicateTitle = Object.values(fundAssets).some(
      (asset) => asset.displayTitle.toLowerCase() === assetTitleTrimmed.toLowerCase()
    );
    if (duplicateTitle) {
      alert("An asset with this name already exists.");
      return;
    }

    // Determine the next index by finding the maximum existing index and adding 1
    const maxIndex = Math.max(
      -1,
      ...Object.values(fundAssets)
        .filter((asset) => !excludedAssetKeys.includes(asset.displayTitle.toLowerCase()))
        .map((asset) => asset.index ?? 0)
    );

    // Initialize the new asset in clientState.assets using the correct dynamic key
    const newState: Client = {
      ...clientState,
      assets: {
        ...clientState.assets,
        [currentFundKey]: {
          ...fundAssets,
          [newAssetType]: {
            amount: 0,
            firstDepositDate: new Date(),
            displayTitle: assetTitleTrimmed,
            index: maxIndex + 1, // Assign the next index
          },
        },
      },
    };
    setClientState(newState);

    // Close the modal
    closeAddAssetModal();
  };

  // Function to handle removing an asset
  const handleRemoveAsset = (fundKey: string, assetType: string) => {
    // Prevent removing protected assets and excluded keys
    if (excludedAssetKeys.includes(assetType.toLowerCase())) {
      alert("This asset cannot be removed.");
      return;
    }

    if (!window.confirm(`Are you sure you want to remove the asset "${assetType}"?`)) {
      return;
    }

    // Remove from clientState.assets
    const fundAssets = { ...clientState.assets[fundKey] };
    delete fundAssets[assetType];

    // After deletion, reassign indices to maintain order consistency
    const updatedAssetsArray = Object.entries(fundAssets)
      .filter(([type]) => !excludedAssetKeys.includes(type.toLowerCase()))
      .sort(([, a], [, b]) => (a.index ?? 0) - (b.index ?? 0))
      .map(([type, asset], idx) => {
        asset.index = idx;
        return [type, asset];
      });

    const updatedAssets = Object.fromEntries(updatedAssetsArray);

    const newState: Client = {
      ...clientState,
      assets: {
        ...clientState.assets,
        [fundKey]: updatedAssets,
      },
    };
    setClientState(newState);
  };

  // Function to handle editing an asset title
  const handleEditAsset = (fundKey: string, assetType: string, newAssetTitle: string) => {
    const assetTitleTrimmed = newAssetTitle.trim();
    if (assetTitleTrimmed === "") {
      alert("Asset name cannot be empty.");
      return;
    }

    // Prevent renaming to 'total', 'Total', 'fund', 'Fund'
    if (excludedAssetKeys.includes(assetTitleTrimmed.toLowerCase())) {
      alert("The asset name 'total' or 'fund' is reserved and cannot be used.");
      return;
    }

    // Check for duplicate asset titles within the same fund
    const fundAssets = clientState.assets[fundKey];
    const duplicateTitle = Object.values(fundAssets).some(
      (assetDetail) =>
        assetDetail.displayTitle.toLowerCase() === assetTitleTrimmed.toLowerCase() &&
        assetType !== assetDetail.displayTitle.toLowerCase().replace(/\\s+/g, "-") // Ensure we are not comparing to itself if title hasn't changed much
    );
    if (duplicateTitle) {
      alert("An asset with this name already exists in this fund.");
      return;
    }

    // Update clientState.assets
    const assetToUpdate = fundAssets[assetType];
    const updatedAssetDetails = {
      ...assetToUpdate,
      displayTitle: assetTitleTrimmed,
    };

    const updatedFundAssets = {
      ...fundAssets,
      [assetType]: updatedAssetDetails, // Use the original assetType as the key
    };

    const newState: Client = {
      ...clientState,
      assets: {
        ...clientState.assets,
        [fundKey]: updatedFundAssets,
      },
    };
    setClientState(newState);
  };

  // Function to move an asset up in the order
  const handleMoveAssetUp = (fundKey: string, assetType: string) => {
    const fundAssets = { ...clientState.assets[fundKey] };
    const assetsArray = Object.entries(fundAssets)
      .filter(([type]) => !excludedAssetKeys.includes(type.toLowerCase()))
      .sort(([, a], [, b]) => (a.index ?? 0) - (b.index ?? 0));

    const index = assetsArray.findIndex(([type]) => type === assetType);

    if (index > 0) {
      const prevAssetType = assetsArray[index - 1][0];
      const currentAsset = fundAssets[assetType];
      const prevAsset = fundAssets[prevAssetType];

      // Swap indices
      const tempIndex = currentAsset.index;
      currentAsset.index = prevAsset.index;
      prevAsset.index = tempIndex;

      const newState: Client = {
        ...clientState,
        assets: {
          ...clientState.assets,
          [fundKey]: {
            ...fundAssets,
            [assetType]: currentAsset,
            [prevAssetType]: prevAsset,
          },
        },
      };
      setClientState(newState);
    }
  };

  // Function to move an asset down in the order
  const handleMoveAssetDown = (fundKey: string, assetType: string) => {
    const fundAssets = { ...clientState.assets[fundKey] };
    const assetsArray = Object.entries(fundAssets)
      .filter(([type]) => !excludedAssetKeys.includes(type.toLowerCase()))
      .sort(([, a], [, b]) => (a.index ?? 0) - (b.index ?? 0));

    const index = assetsArray.findIndex(([type]) => type === assetType);

    if (index < assetsArray.length - 1) {
      const nextAssetType = assetsArray[index + 1][0];
      const currentAsset = fundAssets[assetType];
      const nextAsset = fundAssets[nextAssetType];

      // Swap indices
      const tempIndex = currentAsset.index;
      currentAsset.index = nextAsset.index;
      nextAsset.index = tempIndex;

      const newState: Client = {
        ...clientState,
        assets: {
          ...clientState.assets,
          [fundKey]: {
            ...fundAssets,
            [assetType]: currentAsset,
            [nextAssetType]: nextAsset,
          },
        },
      };
      setClientState(newState);
    }
  };

  return (
    <CContainer className="py-3">
      {Object.entries(clientState.assets).map(([fundKey, fundAssets]) => (
        <div key={fundKey} className="mb-5">
          <div className="mb-2 pb-3">
            <h5>{fundKey.toUpperCase()} Fund Assets</h5>
          </div>
          {/* ...existing asset mapping code... */}
          {Object.entries(fundAssets)
            .filter(([assetType]) => !["total", "fund"].includes(assetType.toLowerCase()))
            .sort(([, a], [, b]) => (a.index ?? 0) - (b.index ?? 0))
            .map(([assetType, asset], index) => {
              const isFirst = index === 0;
              const isLast = index === Object.keys(fundAssets).length - 1;
              let isDisabled = viewOnly;
              if (!isDisabled && activeFund !== undefined && fundKey.toUpperCase() !== activeFund.toUpperCase()) {
                isDisabled = true;
              }
              return (
                <AssetFormComponent
                  key={`${fundKey}-${assetType}`}
                  title={asset.displayTitle}
                  id={`${fundKey}-${assetType}`}
                  fundKey={fundKey}
                  assetType={assetType}
                  clientState={clientState}
                  setClientState={setClientState}
                  disabled={isDisabled}
                  incrementAmount={incrementAmount}
                  onRemove={handleRemoveAsset}
                  onEdit={handleEditAsset}
                  onMoveUp={handleMoveAssetUp}
                  onMoveDown={handleMoveAssetDown}
                  isEditable={!isDisabled}
                  isFirst={isFirst}
                  isLast={isLast}
                />
              );
            })}
          {!viewOnly && (
            <div className="mt-3 d-flex justify-content-between align-items-center">
              <div>
                <CButton color="primary" onClick={() => openAddAssetModal(fundKey)}>
                  <CIcon icon={cilPlus} className="me-1" />
                  Add Asset
                </CButton>
              </div>
              <div className="d-flex gap-2">
                <CButton color="success" variant="outline" onClick={openAddFundModal}>
                  <CIcon icon={cilFolder} className="me-1" />
                  Add Fund
                </CButton>
                <CButton color="danger" variant="outline" size="sm" onClick={() => handleDeleteFund(fundKey)}>
                  <CIcon icon={cilTrash} className="me-1" />
                  Delete Fund
                </CButton>
              </div>
            </div>
          )}
        </div>
      ))}

      {/* Existing Modals */}
      <CModal visible={isModalOpen} onClose={closeAddAssetModal} alignment="center">
        <CModalHeader>Add New Asset</CModalHeader>
        <CModalBody>
          <CFormInput
            label="Asset Name"
            placeholder="Enter asset name"
            value={newAssetTitle}
            onChange={(e) => setNewAssetTitle(e.target.value.replace(/["']/g, ""))}
          />
        </CModalBody>
        <CModalFooter>
          <CButton color="secondary" onClick={closeAddAssetModal}>
            Cancel
          </CButton>
          <CButton color="primary" onClick={handleAddAsset}>
            Add
          </CButton>
        </CModalFooter>
      </CModal>

      <CModal visible={isFundModalOpen} onClose={closeAddFundModal} alignment="center">
        <CModalHeader>Add New Fund</CModalHeader>
        <CModalBody>
          <CFormInput
            label="Fund Name"
            placeholder="Enter fund name"
            value={newFundName}
            onChange={(e) => setNewFundName(e.target.value.replace(/["']/g, ""))}
          />
        </CModalBody>
        <CModalFooter>
          <CButton color="secondary" onClick={closeAddFundModal}>
            Cancel
          </CButton>
          <CButton color="success" variant="outline" onClick={handleAddFund}>
            Add Fund
          </CButton>
        </CModalFooter>
      </CModal>
    </CContainer>
  );
};