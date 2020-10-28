# PrEnvironment.ForDevs
This repository contains an example for how to use Github Actions in combination with Terraform (Infrastructure as Code) to create a test environment for incoming Pull Requests. 
Once the Pull Request is merged or closed the environment will be deleted again.

Please note that the workflow is not active, but is available here: https://github.com/sitereactor/PrEnvironment.ForDevs/blob/master/workflows/pr-build-deploy-destroy.yml

The workflow has 3 jobs: 
- Provisioning an Azure App Service WebApp using terraform: https://github.com/sitereactor/PrEnvironment.ForDevs/blob/master/workflows/pr-build-deploy-destroy.yml#L20
- Building and deploying the sample web application from this repository, which is the second step that will run: https://github.com/sitereactor/PrEnvironment.ForDevs/blob/master/workflows/pr-build-deploy-destroy.yml#L83
- Destroying (deleting) the test environment using the terraform state from the Provisioning job - this happens when the Pull Request is merged or closed: https://github.com/sitereactor/PrEnvironment.ForDevs/blob/master/workflows/pr-build-deploy-destroy.yml#L136

Note the secrets used here: https://github.com/sitereactor/PrEnvironment.ForDevs/blob/master/workflows/pr-build-deploy-destroy.yml#L41-L44 which are added to the secrets store for this repository.

The terraform used as part of this workflow can be found here: https://github.com/sitereactor/PrEnvironment.ForDevs/tree/master/infrastructure/pr-environment
It creates and connects the following for each pull request:
- Azure App Service Plan and WebApp
- Azure SQL Server and Database
- Application Insights

Note that the trigger could be enabled to only run when there is changes to the Web Application project and nothing else. 
The approach to doing this can be seen here although it is not enabled: https://github.com/sitereactor/PrEnvironment.ForDevs/blob/master/workflows/pr-build-deploy-destroy.yml#L8-L13
