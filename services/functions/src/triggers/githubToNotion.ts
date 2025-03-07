import * as functions from 'firebase-functions';
import { Client } from '@notionhq/client';

export const githubToNotion = functions.https.onRequest( 
  { secrets: ['NOTION_API_KEY', 'NOTION_DATABASE_ID', 'NOTION_USER_ID_ZAMIN', 'NOTION_USER_ID_OMAR'] },
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
    
    // Function to create a Notion page for an issue
    async function createNotionPage(issue: any) {
      const pageData: any = {
      parent: { "type": "database_id", "database_id": databaseId },
      properties: {
        "Task name": {
        title: [{ text: { content: issue.title } }]
        },
        "Github Issue": {
        url: issue.html_url
        },
        "Github Issue #": {
        number: issue.number
        }
      }
      };

      if (issue.body) {
      pageData.children = [
        {
        object: 'block',
        type: 'paragraph',
        paragraph: {
          rich_text: [
          {
            type: 'text',
            text: {
            content: issue.body
            }
          }
          ]
        }
        }
      ];
      }

      return notion.pages.create(pageData);
    }

    // Function to find a Notion page for an issue number
    async function findNotionPageForIssue(issueNumber: number) {
      const randomDelay = Math.floor(Math.random() * (15000 - 2000 + 1)) + 2000;
      await new Promise(resolve => setTimeout(resolve, randomDelay));
      const response = await notion.databases.query({
        database_id: databaseId,
        filter: {
          property: "Github Issue #",
          number: { equals: issueNumber }
        }
      });
      return response.results.length > 0 ? response.results[0] : null;
    }

    if (event === 'issues') {
      const issue = req.body.issue;
      const action = req.body.action;
      
      try {
        // Handle issue opened event
        if (action === 'opened') {
          let notionPage = await findNotionPageForIssue(issue.number);
          if (notionPage) {
            console.log('Notion page already exists for issue:', issue.number);
            res.status(200).send('Notion page already exists');
            return;
          }
          await createNotionPage(issue);
          console.log('Created Notion page for issue:', issue.number);

        } else if (action === 'assigned') {
          console.log('Processing assignment for issue:', issue.number);
          
          // Find existing page or create it if it doesn't exist
          let notionPage = await findNotionPageForIssue(issue.number);
          
          // If page doesn't exist (race condition), create it first
          if (!notionPage) {
            console.log('Page not found - creating it first (race condition)');
            const newPage = await createNotionPage(issue);
            notionPage = newPage;
          }
          
          // Map GitHub username to Notion user ID
          const assignees: any[] = issue.assignees;
          let notionAssignees = [];

          for (const assignee of assignees){
            if (assignee.login === 'zaminshaikh') {
              notionAssignees.push({id: process.env.NOTION_USER_ID_ZAMIN});
            } else if (assignee.login === 'omarsyed4') {
              notionAssignees.push({id: process.env.NOTION_USER_ID_OMAR});
            } 
          }
          
          // Only update if we have a mapping for this user
          if (notionAssignees) {
            await notion.pages.update({
              page_id: notionPage.id,
              properties: {
                "Assignee": {
                  people: notionAssignees as any
                }
              }
            });
            console.log(`Assigned issue ${issue.number} to ${notionAssignees} in Notion`);
          } else {
            console.log(`No Notion user mapping found for GitHub user: ${notionAssignees}`);
          }
        } else if (action === 'closed') {
          console.log('Processing close for issue:', issue.number);
          
          // Find existing page or create it if it doesn't exist
          let notionPage = await findNotionPageForIssue(issue.number);
          
          // If page doesn't exist
          if (!notionPage) {
            console.log('Page not found');
            return;
          }

          if (issue.state_reason === 'not_planned' || issue.state_reason === 'duplicate') {
            await notion.pages.update({
              page_id: notionPage.id,
              properties: {
                "Status": {
                  status: { name: 'Archived' }
                }
              }
            });
          } else {
            await notion.pages.update({
              page_id: notionPage.id,
              properties: {
                "Status": {
                  status: { name: 'Done' }
                }
              }
            });
          }
        } else if (action === 'reopened') {
          console.log('Processing reopen for issue:', issue.number);
          
          // Find existing page or create it if it doesn't exist
          let notionPage = await findNotionPageForIssue(issue.number);
          
          // If page doesn't exist
          if (!notionPage) {
            throw new Error('Page not found');
            return;
          }

          await notion.pages.update({
            page_id: notionPage.id,
            properties: {
              "Status": {
                status: { name: 'Not started' }
              }
            }
          });
        }

        
        // Acknowledge the webhook
        res.status(200).send('Webhook processed successfully');
        
      } catch (error) {
        console.error('Error processing webhook:', error);
        const errorMessage = error instanceof Error ? error.message : String(error);
        res.status(500).send(`Error processing webhook: ${errorMessage}`);
      }
    } else if (event === 'create') {
      try {
        // Check if this is a branch creation (not tag)
        if (req.body.ref_type === 'branch') {
          const branchName = req.body.ref;
          console.log(`Branch created: ${branchName}`);
          
          // Extract characters before first '-'
          const firstDashIndex = branchName.indexOf('-');
          if (firstDashIndex > 0) {
            const potentialIssueNumber = branchName.substring(0, firstDashIndex);
            
            // Check if it's a valid number
            const issueNumber = parseInt(potentialIssueNumber);
            if (!isNaN(issueNumber)) {
              console.log(`Detected potential issue #${issueNumber} from branch ${branchName}`);
              
              // Find corresponding Notion page
              const notionPage = await findNotionPageForIssue(issueNumber);
              
              if (notionPage) {
                // Update status to "In progress"
                await notion.pages.update({
                  page_id: notionPage.id,
                  properties: {
                    "Status": {
                      status: { name: 'In progress' }
                    }
                  }
                });
                console.log(`Updated status to "In progress" for issue #${issueNumber}`);
              } else {
                console.log(`No Notion page found for issue #${issueNumber}`);
              }
            }
          }
        }
        res.status(200).send('Branch creation webhook processed');
      } catch (error) {
        console.error('Error processing branch creation webhook:', error);
        const errorMessage = error instanceof Error ? error.message : String(error);
        res.status(500).send(`Error processing branch creation webhook: ${errorMessage}`);
      }
    } else {
      // Not an issue event
      console.log(`Ignoring non-issue event: ${event}`);
      res.status(200).send('Ignored non-issue event');
    }
  }
);