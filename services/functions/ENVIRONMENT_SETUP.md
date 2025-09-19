# Firebase Functions Environment Setup

## Required Environment Variables

### Resend API Configuration

To enable email invitations, you need to set up the Resend API key:

```bash
# Set the Resend API key for email functionality
firebase functions:config:set resend.api_key="your_resend_api_key_here"
```

**Important Security Notes:**
- Never commit API keys to version control
- Use Firebase Functions configuration for production
- Use local environment variables for development

## Development Setup

1. **Install Firebase CLI** (if not already installed):
   ```bash
   npm install -g firebase-tools
   ```

2. **Login to Firebase**:
   ```bash
   firebase login
   ```

3. **Set the Resend API key**:
   ```bash
   firebase functions:config:set resend.api_key="YOUR_RESEND_API_KEY_HERE"
   ```

4. **Verify configuration**:
   ```bash
   firebase functions:config:get
   ```

5. **For local development**, create a `.env` file in the functions directory:
   ```bash
   # services/functions/.env
   RESEND_API_KEY=YOUR_RESEND_API_KEY_HERE
   ```

## Deployment

When deploying functions, the environment variables are automatically included:

```bash
# Build and deploy functions
npm run deploy
```

## Environment Variable Access

In your functions code, access environment variables using:

```typescript
// For Firebase Functions config
const resendApiKey = functions.config().resend.api_key;

// For local development with .env
const resendApiKey = process.env.RESEND_API_KEY;
```

## Security Best Practices

1. **Never expose API keys in source code**
2. **Use different API keys for development and production**
3. **Regularly rotate API keys**
4. **Monitor API usage and set up alerts**
5. **Restrict API key permissions to minimum required**

## Troubleshooting

### Common Issues:

1. **"RESEND_API_KEY environment variable is required"**
   - Ensure the environment variable is set correctly
   - Check Firebase Functions configuration: `firebase functions:config:get`

2. **Email sending fails**
   - Verify the API key is valid
   - Check Resend dashboard for quota limits
   - Ensure the sender domain is verified in Resend

3. **CORS errors**
   - The function includes CORS headers for cross-origin requests
   - Verify the admin dashboard is calling the correct endpoint

## Function Endpoints

After deployment, the sendInviteEmail function will be available at:
```
https://us-central1-[your-project-id].cloudfunctions.net/sendInviteEmail
```

## Testing

You can test the function locally using:

```bash
# Start the Firebase emulator
npm run serve

# The function will be available at:
# http://localhost:5001/[your-project-id]/us-central1/sendInviteEmail
```
