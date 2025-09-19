/**
 * @file sendInviteEmail.ts
 * @description Firebase Cloud Function to send invitation emails to clients using Resend API.
 *              Includes CORS support and professional email template with ARMM Group branding.
 */

import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
// Using fetch API for HTTP requests instead of Resend SDK to avoid React dependencies
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

// Resend API configuration

/**
 * Callable Cloud Function: sendInviteEmail
 * 
 * @description Sends a professional invitation email to clients with ARMM Group branding
 * @param {Object} req.body - Request body containing client information
 * @param {string} req.body.clientName - Client's first name
 * @param {string} req.body.clientEmail - Client's email address
 * @param {string} req.body.cid - Client ID
 * @returns {Promise<{ success: boolean, messageId?: string, error?: string }>}
 */
export const sendInviteEmail = functions.https.onRequest(async (req, res) => {
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

      // Verify authentication (optional - add your auth logic here)
      const { clientName, clientEmail, cid } = req.body;

      if (!clientName || !clientEmail || !cid) {
        res.status(400).json({ 
          success: false, 
          error: "Missing required fields: clientName, clientEmail, cid" 
        });
        return;
      }

      // Generate the professional email HTML
      const emailHtml = generateInviteEmailHtml(clientName, cid);
      const emailText = generateInviteEmailText(clientName, cid);

      // Send email using Resend REST API
      const emailResponse = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${RESEND_API_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          from: "invite@app.armmgroup.com",
          to: [clientEmail],
          subject: "Welcome to ARMM Group - Your Investment App Invitation",
          html: emailHtml,
          text: emailText,
        })
      });

      const emailResult = await emailResponse.json();

      if (!emailResponse.ok) {
        throw new Error(`Resend API error: ${emailResult.message || 'Unknown error'}`);
      }

      // Log the invitation for audit purposes
      await admin.firestore().collection("invitations").add({
        clientName,
        clientEmail,
        cid,
        sentAt: admin.firestore.Timestamp.now(),
        messageId: emailResult.id,
        status: "sent"
      });

      res.status(200).json({
        success: true,
        messageId: emailResult.id,
        message: "Invitation email sent successfully"
      });

    } catch (error) {
      console.error("Error sending invitation email:", error);
      
      // Log error for debugging
      await admin.firestore().collection("invitations").add({
        clientEmail: req.body.clientEmail,
        cid: req.body.cid,
        sentAt: admin.firestore.Timestamp.now(),
        status: "failed",
        error: error instanceof Error ? error.message : "Unknown error"
      });

      res.status(500).json({
        success: false,
        error: "Failed to send invitation email"
      });
    }
  });
});

/**
 * Generate professional HTML email template with ARMM Group branding
 */
function generateInviteEmailHtml(clientName: string, cid: string): string {
  return `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="color-scheme" content="light">
    <meta name="supported-color-schemes" content="light">
    <title>ARMM Group - Investment App Invitation</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+Balinese:wght@400;700&family=Open+Sans:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Open Sans', Arial, sans-serif;
            line-height: 1.6;
            color: #333333 !important;
            background-color: #f8f9fa !important;
            -webkit-text-size-adjust: 100%;
            -ms-text-size-adjust: 100%;
        }
        .email-container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff !important;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .header {
            background: linear-gradient(135deg, #2B41B8 0%, #4A5BC7 100%) !important;
            padding: 30px 40px;
            text-align: center;
            color: white !important;
        }
        .logo-container {
            margin-bottom: 20px;
        }
        .logo {
            max-width: 200px;
            height: auto;
        }
        .header-title {
            font-family: 'Noto Serif Balinese', serif;
            font-size: 28px;
            font-weight: 700;
            margin: 0;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }
        .header-subtitle {
            font-size: 16px;
            margin: 10px 0 0 0;
            opacity: 0.95;
        }
        .content {
            padding: 40px;
        }
        .greeting {
            font-size: 18px;
            color: #2B41B8;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .main-text {
            font-size: 16px;
            margin-bottom: 25px;
            color: #4a4a4a;
        }
        .steps-container {
            background-color: #f8f9fb;
            border-left: 4px solid #2B41B8;
            padding: 25px;
            margin: 30px 0;
            border-radius: 0 8px 8px 0;
        }
        .steps-title {
            font-family: 'Noto Serif Balinese', serif;
            font-size: 20px;
            color: #2B41B8;
            margin-bottom: 20px;
            font-weight: 700;
        }
        .step {
            margin-bottom: 20px;
            display: flex;
            align-items: flex-start;
        }
        .step-number {
            background-color: #2B41B8;
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
            margin-right: 15px;
            flex-shrink: 0;
        }
        .step-content {
            flex: 1;
        }
        .step-title {
            font-weight: 600;
            color: #2B41B8;
            margin-bottom: 5px;
        }
        .download-links {
            background-color: #ffffff;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            margin: 15px 0;
        }
        .download-link {
            display: block;
            background-color: #2B41B8 !important;
            color: white !important;
            text-decoration: none;
            padding: 12px 20px;
            border-radius: 6px;
            margin: 10px 0;
            text-align: center;
            font-weight: 600;
            transition: background-color 0.3s ease;
        }
        .download-link:hover {
            background-color: #1e2d8a !important;
            color: white !important;
        }
        .cid-highlight {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            padding: 15px;
            border-radius: 6px;
            text-align: center;
            margin: 20px 0;
            font-family: 'Courier New', monospace;
            font-size: 18px;
            font-weight: bold;
            color: #856404;
        }
        .important-note {
            background-color: #e7f3ff;
            border-left: 4px solid #2B41B8;
            padding: 15px;
            margin: 20px 0;
            border-radius: 0 6px 6px 0;
        }
        .support-section {
            background-color: #f8f9fa;
            padding: 25px;
            border-radius: 8px;
            margin: 30px 0;
            text-align: center;
        }
        .signature {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #e9ecef;
        }
        .signature-title {
            font-family: 'Noto Serif Balinese', serif;
            font-size: 18px;
            color: #2B41B8;
            margin-bottom: 10px;
        }
        .footer {
            background-color: #2B41B8 !important;
            color: white !important;
            padding: 30px 40px;
            text-align: center;
            font-size: 14px;
        }
        .footer-address {
            margin-bottom: 20px;
            line-height: 1.4;
        }
        .footer-disclaimer {
            font-size: 12px;
            opacity: 0.9;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.2);
        }
        .contact-info {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin: 20px 0;
            flex-wrap: wrap;
        }
        .contact-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        @media (max-width: 600px) {
            .content {
                padding: 20px;
            }
            .header {
                padding: 20px;
            }
            .contact-info {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="email-container">
        <div class="header">
             <div class="logo-container">
                 <svg width="200" height="70" viewBox="0 0 462 161" fill="none" xmlns="http://www.w3.org/2000/svg" style="-webkit-filter: none !important; filter: none !important;">
                    <path d="M204.65 60.8235H182.559L209.918 90.7367H180.395L154.031 60.8235L136.183 40.8814H188.646C194.778 40.8814 199.748 36.194 199.748 30.4118C199.748 24.6295 194.778 19.9421 188.646 19.9421H117.442L99.5928 0H204.65C212.241 0 218.395 5.80346 218.395 12.9624V47.8611C218.395 55.0201 212.241 60.8235 204.65 60.8235Z" fill="white"/>
                    <path d="M78.0508 0.246112L63.0877 16.9508L63.097 16.962L0 90.7367H27.4317L76.7237 34.5331L124.509 90.7367H154.044L78.0508 0.246112Z" fill="white"/>
                    <path d="M158.335 95.8466L158.13 96V95.602L158.335 95.8466Z" fill="white"/>
                    <path d="M76.7736 52.8438L96.2015 74.0352H58.3457L76.7736 52.8438Z" fill="white"/>
                    <path d="M43.0773 90.4874L52.6216 80.7656H101.868L110.413 90.4874H43.0773Z" fill="white"/>
                    <path d="M223.001 30.2464C223.001 43.9168 219 54.4989 213 57.9989C208.5 59.9989 199.748 44.0822 199.748 30.4118C199.748 16.7413 211.666 2.50045 215 4.5C217.5 7 223.001 16.576 223.001 30.2464Z" fill="white"/>
                    <path d="M362.232 0H338.971V0.955856L301.391 59.7472L263.2 0H240V90.7367H262.878V36.8065L288.748 72.7888L301.336 90.7367L313.595 72.7888L338.971 37.9275V90.7367H362.232V37.3392L387.719 72.7888L400.307 90.7367L412.566 72.7888L438.358 37.3544V90.7367H461.202V0H438.358V0.303256L400.362 59.7472L362.232 0.0949131V0Z" fill="white"/>
                </svg>
            </div>
            <h1 class="header-title">Welcome to ARMM Group</h1>
            <p class="header-subtitle">Your Investment Management Platform</p>
        </div>

        <div class="content">
            <div class="greeting">Dear ${clientName},</div>
            
            <p class="main-text">
                We hope this message finds you well. ARMM Group is excited to invite you to access our exclusive investment management application!
            </p>
            
            <p class="main-text">
                With this app, you can easily access your up-to-date investment information, portfolio analytics, and performance metrics right from your mobile device. Our platform is designed to provide you with real-time insights into your investments with the security and professionalism you expect from ARMM Group.
            </p>

            <div class="steps-container">
                <h3 class="steps-title">Getting Started</h3>
                
                <div class="step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <div class="step-title">Download the App</div>
                        <p>Click the appropriate link below based on your device:</p>
                        <div class="download-links">
                            <a href="https://testflight.apple.com/join/e9kMgByH" class="download-link">📱 Download for iOS</a>
                            <a href="https://play.google.com/apps/internaltest/4701740371572084825" class="download-link">🤖 Download for Android</a>
                        </div>
                        <div class="important-note">
                            <strong>Important:</strong> The app is only available on mobile devices. Please open these links directly on your smartphone or tablet.
                        </div>
                    </div>
                </div>

                <div class="step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <div class="step-title">Enter Your Client ID (CID)</div>
                        <p>Use your unique Client ID to set up your account:</p>
                        <div class="cid-highlight">${cid}</div>
                    </div>
                </div>

                <div class="step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <div class="step-title">Complete Account Setup</div>
                        <p>Follow the in-app instructions to create your account using your email and CID. This is a one-time setup process - you won't need to remember your CID for future logins.</p>
                    </div>
                </div>
            </div>

            <div class="support-section">
                <h3 style="color: #2B41B8; margin-bottom: 15px;">Need Assistance?</h3>
                <p>We've designed our platform to be intuitive and user-friendly. If you have any questions or need assistance during setup, our dedicated support team is ready to help.</p>
                <p style="margin-top: 15px;">
                    <strong>Contact us at:</strong> 
                    <a href="mailto:info@armmgroup.com" style="color: #2B41B8; text-decoration: none;">info@armmgroup.com</a>
                </p>
            </div>

            <p class="main-text">
                Thank you for your continued trust in ARMM Group. We are committed to providing you with exceptional investment management services and are excited to bring you a more convenient and seamless experience through our mobile platform.
            </p>

            <div class="signature">
                <p class="signature-title">Cordially,</p>
                <p style="font-weight: 600; color: #2B41B8; margin-bottom: 5px;">The ARMM Group Team</p>
                <p style="font-style: italic; color: #666;">Empowering Financial Success Through Excellence</p>
            </div>
        </div>

        <div class="footer">
            <div class="footer-address">
                <strong>ARMM Group LLC</strong><br>
                6800 Jericho Turnpike, Suite 120W<br>
                Syosset, NY 11791
            </div>
            
            <div class="contact-info">
                <div class="contact-item">
                    <span>📞</span>
                    <span>347-513-3040</span>
                </div>
                <div class="contact-item">
                    <span>✉️</span>
                    <span>info@armmgroup.com</span>
                </div>
            </div>
            
            <div class="footer-disclaimer">
                <strong>Confidentiality Disclaimer:</strong> This e-mail and any attachments may contain information that is confidential or otherwise protected from disclosure. If you are not the intended recipient, please notify the sender immediately and delete this e-mail. Thank you.
            </div>
        </div>
    </div>
</body>
</html>
  `;
}

/**
 * Generate plain text version of the invitation email
 */
function generateInviteEmailText(clientName: string, cid: string): string {
  return `
Dear ${clientName},

We hope this message finds you well. ARMM Group is excited to invite you to access our exclusive investment management application!

With this app, you can easily access your up-to-date investment information, portfolio analytics, and performance metrics right from your mobile device.

GETTING STARTED:

1. Download the App:
   For iOS Users: https://testflight.apple.com/join/e9kMgByH
   For Android Users: https://play.google.com/apps/internaltest/4701740371572084825
   
   Important: The app is only available on mobile devices. Please open these links directly on your smartphone or tablet.

2. Enter Your Client ID (CID): ${cid}

3. Complete Account Setup: Follow the in-app instructions to create your account using your email and CID. This is a one-time setup process.

NEED ASSISTANCE?
If you have any questions or need assistance, contact us at: info@armmgroup.com

Thank you for your continued trust in ARMM Group. We are excited to bring you a more convenient and seamless investment management experience.

Cordially,
The ARMM Group Team

---
ARMM Group LLC
6800 Jericho Turnpike, Suite 120W
Syosset, NY 11791
Phone: 347-513-3040
Email: info@armmgroup.com

Confidentiality Disclaimer: This e-mail and any attachments may contain information that is confidential or otherwise protected from disclosure. Thank you.
  `;
}
