import * as functions from 'firebase-functions';
import { Client } from '@notionhq/client';
// import * as dotenv from 'dotenv';
// import * as path from 'path';

// // Load environment variables from notion.env file
// dotenv.config({ path: path.resolve(__dirname, '../../notion.env') });

export const githubToNotion = functions.https.onRequest( 
  { secrets: ['NOTION_API_KEY', 'NOTION_DATABASE_ID'] },
  async (req, res) => {
    const notion = new Client({ auth: process.env.NOTION_API_KEY });
    const databaseId = process.env.NOTION_DATABASE_ID ?? '';  
    // Only accept POST requests
    if (req.method !== 'POST') {
      res.status(405).send('Method Not Allowed');
      return;
    }

    // Identify the GitHub event type from the header
    const event = req.get('X-GitHub-Event');
    
    // Handle only new issue events
    if (event === 'issues' && req.body.action === 'opened') {
      const issue = req.body.issue;
      try {
        // Create a new page in Notion with properties based on your database schema
        await notion.pages.create({
          parent: { "type": "database_id", "database_id": databaseId },
          properties: {
            // Assuming your database has a Title property named "Name"
            "Task name": {
              title: [
                {
                  text: { content: issue.title }
                }
              ]
            },
            "Github Issue": {
              url: issue.html_url
            },
            "Github Issue #": {
              number: issue.number
            }
          },
        });
      } catch (error) {
        console.error('Error creating Notion page:', error);
        res.status(500).send('Error creating Notion page');
        return;
      }
    }
    // Acknowledge the webhook
    res.status(200).send('Webhook received');
});