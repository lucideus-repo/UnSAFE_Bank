
# UnSAFE Bank
Welcome to UnSAFE Bank - Vulnerable Banking Suite

## About
UnSAFE Bank is a core virtual banking suite designed with the aim to incorporate the novel attack scenarios such that newbie, developers, and security analysts can learn, hack and improvise their vulnerability assessment and penetration testing skills on Web, Android and iOS application.

## Application Features
It currently consists of the following functionalities:
 * Funds Transfer
 * View Account Statement
 * Add/View Beneficiary

Note: New features and vulnerability integration is under development.

## Vulnerability Coverage
Say it intentionally or unintentionally, we have introduced vulnerabilities which varies from low severity to critical severity. 


## Setting up the environment

### Dependencies
1. [git](https://www.atlassian.com/git/tutorials/install-git).
2. [docker-compose](https://docs.docker.com/compose/install/).
3. Make sure that port 80 of your laptop/desktop does not have a running service.
4. Android/iOS device for mobile application testing.

### Setting up the server
1. Clone the repository on your system
`git clone https://github.com/lucideus-repo/UnSAFE_Bank.git`
2. Navigate to the UnSAFE-Bank/Backend directory
`cd UnSAFE-Bank/Backend`
3. Start docker service (if not running) 
`sudo service docker start`
3. Start the containers
`docker-compose up -d`


### Installing and starting up the application
1. Download the **UnSAFE iBank.ipa** file from the **USE_THIS** directory.
2. Install the application to your iPhone/iPad using any of the tools- ideviceinstaller, iFunBox, ios-deploy or Cydia Impactor (recommended).
3. Trust the developer profile (if required).
4. Use `SERVER_IP` and get going with the application's functionality.
**Note**: You can signup as a new user or use any of the accounts provided in the next section. Upon a fresh signup, you would be provided with at most two beneficiaries depending upon the number of existing users.

### Registering as a new user
For every new user who registers as a new user using the signup functionality, a _loginId_ would be provided to the user. Also, the bank account would be created which would give the user an _Account Number_, _Bank Code (IFSC Code)_ and a random _Balance_ in the account that would range from 1 Lakh to 5 Lakh.

### Sample Data
You can use the following data for activities such as add beneficiary, funds transfer etc.
| Account Holder | Account Number | IFSC Code |
| -------------- | -------------- | ----------|
| Rubal Jain | 149812733485 | IFSC00002 |  
| Sahil Pahwa | 261562410205 | IFSC00008 |
| Chetan Kumar | 618850572087 | IFSC00009 |
| Vibhav Dudeja | 263021552894 | IFSC00010 |
**********

### Reporting bugs
If you come across any functional bugs in the application, kindly report the same as issues. We would be happy to resolve them :)

### License
Open Source
