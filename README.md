![](https://repository-images.githubusercontent.com/243465953/e8faaf80-6491-11ea-84c2-8f7116873cff)

## About

UnSAFE Bank is a core virtual banking suite designed with the aim to incorporate the cybersecurity risks and various test cases such that newbie, developers, and security analysts can learn, hack and improvise their vulnerability assessment and penetration testing skills on Web, Android and iOS application.

**Note:** Only Web and iOS application are launched. Android application is under development.

## Application Features

It currently consists of the following functionalities:

- Funds Transfer
- View Account Statement
- Manage Beneficiary
- Loans
- Account Settings
- Contact us
- About us

**Note:** New features and vulnerability integration is under development.

## Vulnerability Coverage

Say it intentionally or unintentionally, we have introduced vulnerabilities which varies from low severity to critical severity.

To provide you a reference, the following classes of vulnerabilities will be encountered in the applications:

| OWASP Top 10 2017             | OWASP Mobile Top 10 2016      |
| ------------------------------- | ----------------------------- |
| A1: Injection                   | M1: Improper Platform Usage   |
| A2: Broken Authentication       | M2: Insecure Data Storage     |
| A3: Sensitive Data Exposure     | M3: Insecure Communication    |
| A4: XML External Entities (XXE) | M4: Insecure Authentication   |
| A5: Broken Access Control       | M5: Insufficient Cryptography |
| A6: Security Misconfiguration   | M6: Insecure Authorization    |
| A7: Cross-Site Scripting (XSS)  | M7: Client Code Quality       |
| A8: Insecure Deserialization    | M8: Code Tampering            |
|                                 | M9: Reverse Engineering       |


## Setting up the environment

### Dependencies

1. Install [git](https://www.atlassian.com/git/tutorials/install-git) on your system.
2. Install [docker-compose](https://docs.docker.com/compose/install/) on your system.
3. Make sure that port 80 of your laptop/desktop does not have a running service.
4. Android/iOS phone would be required for mobile application testing.

### Setting up the server

1. Clone the repository on your system (Laptop/Desktop)
   `git clone https://github.com/lucideus-repo/UnSAFE_Bank.git`
2. Navigate to the UnSAFE_Bank/Backend directory
   `cd UnSAFE_Bank/Backend`
3. Start docker service (if not running)
   `sudo service docker start`
4. Start the containers
   `docker-compose up -d`

### Installing iOS Application

1. Download and install the [Cydia Impactor](http://www.cydiaimpactor.com/) on your system.
2. Connect your iPhone to the system and open Cydia Impactor.
3. Navigate to the **/iOS/IPA File/** directory.
4. Drag and drop the **UnSAFE Bank.ipa** file on Cydia Impactor.
5. Follow the Cydia Impactor process to complete the installation.
6. Trust the developer profile (if required) and your application would be ready to use.

**Note:** You can always use [other methods](https://mobile-security.gitbook.io/mobile-security-testing-guide/ios-testing-guide/0x06b-basic-security-testing#installing-apps) to install the iOS application as per your convenience.

### Test Connectivity Status (iOS Application)

1. Make sure your iPhone and the server machine are connected to the same network.
2. Check your server's IP address (`ifconfig` or `ipconfig`) and the port (Default port is 80).
3. Open the iOS Application and provide the connection strings on the top right corner to connect to the backend.
4. If there is no error message on your iPhone then "You are connected successfully".
5. If there is an error, make sure your backend is running successfully or you have provided the valid IP address/port.

### Test Connectivity Status (Web Application)

1. Make sure that you are either using the same machine as the server or the server machine is running on a machine on the same local network.
2. Note down the port number of your web application (APP_PORT). Default port is 3000.
3. Check your server's IP address (`ifconfig` or `ipconfig`) and the port (Default port is 80).
4. On any browser, navigate to http://<SERVER_IP>:<APP_PORT> and check if the application is opening.
5. Click on `Test Connection?` and enter the <SERVER_IP> and <SERVER_PORT>.
6. Ensure that the application shows a message `Connection Established` and you are good to go.

### Login Credentials

Customer ID and password is required to login into the application. You can always sign up as a new user in the application.

On successful sign up:

1. You will be provided with your Customer ID corresponding to your account. Always note your Customer ID and keep it SAFE for further usage.
2. Your dummy PII and account information would be generated automatically.
3. Default beneficiaries shall be added in your account automatically.
4. Virtual money shall be added in your account ranging between 1 to 10 lakh.

### Existing User Bank Accounts

Following data can be used to perform actions such as add beneficiary, funds transfer etc.

| Account Holder       | Account Number | IFSC Code |
| -------------------- | -------------- | --------- |
| Vipul Malhotra       | 003558008876   | IFSC00009 |
| Kevin Winkel         | 270365500638   | IFSC00009 |
| Kelly Campbell       | 533074805951   | IFSC00010 |
| Krystal Langworth    | 731258783797   | IFSC00006 |
| Margarita Mann       | 359502423130   | IFSC00010 |
| David Mahabir        | 795554898923   | IFSC00002 |
| Boris Gerhold        | 485064210112   | IFSC00006 |
| Nathaniel Runolfsson | 518569490010   | IFSC00003 |
| Yvette Cooper        | 841478410516   | IFSC00007 |
| Orion Glover         | 001498029143   | IFSC00003 |

### Troubleshooting

Problem 1: Docker containers fail to build on the first attempt.

Problem 2: Internet connection goes away while the docker containers are building up.

Problem 3: You end up inserting junk data or deleting essential data from the database.

> Solution: run the command `docker-compose up -d --build` to build the docker containers fresh.

Problem 4: Error message `listen tcp 0.0.0.0:80: bind: address already in use`.

Problem 5: Error message `listen tcp 0.0.0.0:3000: bind: address already in use`.

> Solution: Check that another service that uses port 80 such as Apache or IIS is down.

Problem 6: Navigating to http://<SERVER_IP>:<SERVER_PORT> gives a message `Service Unavailable`.

> Solution: Wait for 20 to 30 seconds for the services to completely start up.

Problem 7: Web application shows the message `Backend server is unresponsive`.

> Solution 1: Follow the steps mentioned to [check the connectivity status](https://github.com/lucideus-repo/UnSAFE_Bank/blob/master/README.md#test-connectivity-status-web-application) and navigate to http://<SERVER_URL>:<SERVER_PORT>/api. Check if you can get the message `Welcome to UnSAFE Bank`.

### Encountered a bug or want to suggest something?

If you come across any functional bug in the application or want to suggest the improvements, [file an issue](https://github.com/lucideus-repo/UnSAFE_Bank/issues) at this repository. We will look into it at the earliest. :)

### License

This project is using the GNU General Public License v3.0.

### Contributors

[Vibhav Dudeja](https://www.linkedin.com/in/vibhavd), [Tarun Kaushik](https://linkedin.com/in/tarun-kaushik-13827229), [Chetan Kumar](https://www.linkedin.com/in/chetan-daksh-0023b66a/), [Sahil Pahwa](https://www.linkedin.com/in/sahilpahwa1/), [Deepak Pawar](https://www.linkedin.com/in/deepak-singh-pawar/), [Aman Jain](https://www.linkedin.com/in/jn-aman/)

### Owners

[Rubal Jain](https://www.linkedin.com/in/rubaljain-1991)

[Safe Security](https://safe.security)
