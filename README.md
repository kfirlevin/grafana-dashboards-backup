# grafana-dashboard-backup

- [grafana-dashboard-backup](#grafana-dashboard-backup)
  * [Architecture](#architecture)
  * [Parameters](#parameters)

  
In this project we will show you how to backup your Grafana dashboards using Azure DevOps Repos and Azure DevOps Piplines 
    
## Architecture
> ### Azure Repos &rightarrow; cloud-hosted private Git repos for your project
> ### Azure Pipelines &rightarrow; Continuously build, test, and deploy to any platform and cloud.<br/>

   Azure agents will have the option to access each environment and query the dedicated Grafana API and return the result back to Azure Pipelines.<br/>
    <p align="center">
    ![](/images/image1.jpeg)
    </p><br/>
    
   Those step will repeat each environment we would like to backup i.e QA/Sandbox/Production<br/>
    <p align="center">
    ![](/images/image2.png)
    </p><br/>

   let’s see a more detailed view of the flow in one of the above env:
    <p align="center">
    ![](/images/image3.jpeg)
    </p><br/>
    
   The flow will backup each environment to it’s own GIT branch resulting in the below:
    <p align="center">
    ![](/images/image4.png)
    </p><br/>

## Parameters
  - `sourceBranch`: checking out to the branch that you want to commit on it
  - `grafanaToken`: grafana token in order to access the API
  - `grafanaUrl`: grafana site that you want to backup
  - `gitUser`: variable that determine what ends up in the author and committer field of commit objects
  - `gitUserMail`: variable that determine what ends up in the author and committer field of commit objects
