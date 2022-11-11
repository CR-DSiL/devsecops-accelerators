
![GitHub all releases](https://img.shields.io/github/downloads/CR-Digital-Innovation/devsecops-accelerators/total)
![GitHub language count](https://img.shields.io/github/languages/count/CR-Digital-Innovation/devsecops-accelerators)
![GitHub top language](https://img.shields.io/github/languages/top/CR-Digital-Innovation/devsecops-accelerators?color=yellow)
![GitHub forks](https://img.shields.io/github/forks/CR-Digital-Innovation/devsecops-accelerators?style=social)
![GitHub Repo stars](https://img.shields.io/github/stars/CR-Digital-Innovation/devsecops-accelerators?style=social)

[<img src="https://img.shields.io/badge/CriticalRiver-1d417c" width="10%">](https://www.criticalriver.com/ai-ml-solution-offerings/devsecops/) [<img src="https://img.shields.io/badge/Twitter-1DA1F2?logo=Twitter&logoColor=white" width="9%">](https://twitter.com/CriticalRiver)

### CriticalRiver DevSecOps Process

![image](https://user-images.githubusercontent.com/111766830/201345318-d0de846e-6006-4432-8075-2d9450a0c5c6.png)

* Scrum masters or Project Managers would create epics, features, user stories, and tasks. 
* Tasks would be assigned to developers to make the necessary changes, commit the changes to feature branch on which they would be working on. 
* The task will be moved to active from its new state, and a new feature branch will be created for the developers to work on their changes. 
* When the developers commit their changes, a validation build will be triggered to ensure the build is successful with the latest changes. Upon successful completion of the build, the developers will resolve their tasks and raise a pull request for their changes to be merged into the master branch. 
* Once the pull request is approved by the reviewers, the build will be run from the master branch, and SAST tools will be integrated into the build pipeline for code quality checks. 
* After the build is successful from the master branch, the artifacts generated will be stored in the preferred artifacts tool. 
* The release pipelines then pull the artifacts, and the release pre-approvers get an email requesting their approval to deploy. Upon approval, the artifacts are deployed onto development, QA, and finally production using the preferred deployment strategy. 
* The release pipeline would be integrated with DAST tools, which will scan the application for vulnerabilities. 
* When the application has been successfully deployed, a notification will be sent to the team regarding the deployment status. 
* Using the preferred monitoring tools, environments will be continuously monitored for errors. In case of any error logging, a bug will be raised and assigned back to the developers.
