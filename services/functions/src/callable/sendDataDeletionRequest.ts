/**
 * @file sendDataDeletionRequest.ts
 * @description Firebase Cloud Function to handle data deletion requests from users.
 *              Sends an email to info@armmgroup.com with the user's CID and deletion request details.
 */

import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
import cors from "cors";

// Initialize CORS with proper configuration
const corsHandler = cors({
  origin: true, // Allow all origins for development, restrict in production
  methods: ["POST", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
});

// Initialize Resend with API key from Firebase Functions configuration
const RESEND_API_KEY = functions.config().resend?.api_key;

if (!RESEND_API_KEY) {
  throw new Error("RESEND_API_KEY is not configured. Please set it using: firebase functions:config:set resend.api_key=your_api_key");
}

/**
 * HTTP Cloud Function: sendDataDeletionRequest
 * 
 * @description Handles data deletion requests by sending an email to info@armmgroup.com
 * @param {Object} req.body - Request body containing user information
 * @param {string} req.body.cid - Client ID
 * @param {string} req.body.email - User's email address
 * @param {string} req.body.reason - Reason for deletion request (optional)
 * @returns {Promise<{ success: boolean, messageId?: string, error?: string }>}
 */
export const sendDataDeletionRequest = functions.https.onRequest(async (req, res) => {
  return corsHandler(req, res, async () => {
    try {
      // Handle preflight OPTIONS request
      if (req.method === "OPTIONS") {
        res.status(200).send();
        return;
      }

      // Only allow POST requests
      if (req.method !== "POST") {
        res.status(405).json({ success: false, error: "Method not allowed" });
        return;
      }

      const { cid, email, reason } = req.body;

      if (!cid || !email) {
        res.status(400).json({ 
          success: false, 
          error: "Missing required fields: cid, email" 
        });
        return;
      }

      // Basic email validation
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email)) {
        res.status(400).json({ 
          success: false, 
          error: "Invalid email format" 
        });
        return;
      }

      // Generate the email content
      const emailHtml = generateDeletionRequestEmailHtml(cid, email, reason);
      const emailText = generateDeletionRequestEmailText(cid, email, reason);

      // Send email using Resend REST API
      const emailResponse = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${RESEND_API_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          from: "noreply@app.armmgroup.com",
          to: ["zaminusa@gmail.com"],
          subject: `Data Deletion Request - Client ID: ${cid}`,
          html: emailHtml,
          text: emailText,
          reply_to: email,
        })
      });

      const emailResult = await emailResponse.json();

      if (!emailResponse.ok) {
        throw new Error(`Resend API error: ${emailResult.message || 'Unknown error'}`);
      }

      // Log the deletion request for audit purposes
      await admin.firestore().collection("dataDeletionRequests").add({
        cid,
        email,
        reason: reason || "No specific reason provided",
        requestedAt: admin.firestore.Timestamp.now(),
        messageId: emailResult.id,
        status: "submitted",
        ipAddress: req.ip || "unknown",
        userAgent: req.get('User-Agent') || "unknown"
      });

      res.status(200).json({
        success: true,
        messageId: emailResult.id,
        message: "Data deletion request submitted successfully"
      });

    } catch (error) {
      console.error("Error sending data deletion request:", error);
      
      // Log error for debugging
      try {
        await admin.firestore().collection("dataDeletionRequests").add({
          cid: req.body?.cid || "unknown",
          email: req.body?.email || "unknown",
          requestedAt: admin.firestore.Timestamp.now(),
          status: "failed",
          error: error instanceof Error ? error.message : "Unknown error",
          ipAddress: req.ip || "unknown",
          userAgent: req.get('User-Agent') || "unknown"
        });
      } catch (logError) {
        console.error("Error logging failed deletion request:", logError);
      }

      res.status(500).json({
        success: false,
        error: "Failed to submit data deletion request"
      });
    }
  });
});

/**
 * Generate HTML email template for data deletion requests
 */
function generateDeletionRequestEmailHtml(cid: string, email: string, reason: string): string {
  const currentDate = new Date().toLocaleString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    timeZoneName: 'short'
  });

  return `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Data Deletion Request</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333333;
            background-color: #f8f9fa;
        }
        .email-container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .header {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            padding: 30px 40px;
            text-align: center;
            color: white;
        }
        .header-title {
            font-size: 24px;
            font-weight: 700;
            margin: 0;
        }
        .header-subtitle {
            font-size: 14px;
            margin: 10px 0 0 0;
            opacity: 0.95;
        }
        .content {
            padding: 40px;
        }
        .alert-box {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 20px;
            margin: 20px 0;
            border-radius: 0 4px 4px 0;
        }
        .alert-title {
            font-weight: 700;
            color: #856404;
            margin-bottom: 10px;
        }
        .detail-section {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 20px;
            margin: 20px 0;
        }
        .detail-row {
            display: flex;
            margin-bottom: 10px;
            align-items: flex-start;
        }
        .detail-label {
            font-weight: 600;
            min-width: 120px;
            color: #495057;
        }
        .detail-value {
            flex: 1;
            word-break: break-all;
        }
        .reason-box {
            background-color: #e9ecef;
            border-radius: 4px;
            padding: 15px;
            font-style: italic;
            margin-top: 10px;
        }
        .footer {
            background-color: #6c757d;
            color: white;
            padding: 20px 40px;
            text-align: center;
            font-size: 12px;
        }
        .priority-notice {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 6px;
            padding: 15px;
            margin: 20px 0;
            color: #721c24;
        }
    </style>
</head>
<body>
    <div class="email-container">
        <div class="header">
            <h1 class="header-title">🗑️ Data Deletion Request</h1>
            <p class="header-subtitle">User Account & Data Removal Request</p>
        </div>

        <div class="content">
            <div class="alert-box">
                <div class="alert-title">⚠️ URGENT: Data Deletion Request Received</div>
                <p>A user has submitted a request to delete their account and all associated data from ARMM Group systems. This request requires immediate attention and processing within 30 days as per data protection regulations.</p>
            </div>

            <div class="detail-section">
                <h3 style="margin-top: 0; color: #dc3545;">Request Details</h3>
                
                <div class="detail-row">
                    <span class="detail-label">Client ID (CID):</span>
                    <span class="detail-value"><strong>${cid}</strong></span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">Email Address:</span>
                    <span class="detail-value"><strong>${email}</strong></span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">Request Date:</span>
                    <span class="detail-value">${currentDate}</span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">Reason:</span>
                    <div class="detail-value">
                        <div class="reason-box">
                            ${reason || 'No specific reason provided'}
                        </div>
                    </div>
                </div>
            </div>

            <div class="priority-notice">
                <h4 style="margin-top: 0;">🚨 Next Steps Required:</h4>
                <ol style="margin-bottom: 0; padding-left: 20px;">
                    <li><strong>Verify Identity:</strong> Contact the user at <a href="mailto:${email}">${email}</a> to confirm this request</li>
                    <li><strong>Review Account:</strong> Check all systems for data associated with CID: ${cid}</li>
                    <li><strong>Process Deletion:</strong> Remove all personal data from databases, backups, and systems</li>
                    <li><strong>Document Completion:</strong> Log the deletion completion and notify the user</li>
                </ol>
            </div>

            <p><strong>Important:</strong> This is an automated message generated from the ARMM Group data deletion request form. Please handle this request with appropriate urgency and ensure compliance with all applicable data protection regulations.</p>
        </div>

        <div class="footer">
            <p>ARMM Group Data Protection System<br>
            Generated: ${currentDate}</p>
        </div>
    </div>
</body>
</html>
  `;
}

/**
 * Generate plain text version of the data deletion request email
 */
function generateDeletionRequestEmailText(cid: string, email: string, reason: string): string {
  const currentDate = new Date().toLocaleString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    timeZoneName: 'short'
  });

  return `
URGENT: DATA DELETION REQUEST RECEIVED

A user has submitted a request to delete their account and all associated data from ARMM Group systems.

REQUEST DETAILS:
================
Client ID (CID): ${cid}
Email Address: ${email}
Request Date: ${currentDate}
Reason: ${reason || 'No specific reason provided'}

NEXT STEPS REQUIRED:
===================
1. Verify Identity: Contact the user at ${email} to confirm this request
2. Review Account: Check all systems for data associated with CID: ${cid}
3. Process Deletion: Remove all personal data from databases, backups, and systems
4. Document Completion: Log the deletion completion and notify the user

IMPORTANT: This request requires immediate attention and processing within 30 days as per data protection regulations.

This is an automated message generated from the ARMM Group data deletion request form.

---
ARMM Group Data Protection System
Generated: ${currentDate}
  `;
}
