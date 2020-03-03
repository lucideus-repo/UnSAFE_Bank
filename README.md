
# UnSAFE Bank
Welcome to UnSAFE Bank - a vulnerable mobile banking iOS application. The frontend has been written in Swift whereas the backend in CodeIgniter3 (PHP).

## About
UnSAFE Bank application is a core banking application. It currently consists of the following functionality:
 * Signup
 * Login
 * View Account Details
 * List Beneficiary
 * View Beneficiary details
 * Add Beneficiary
 * Logout

There are more modules planned for the versions to come.

### Dependencies
1. [git](https://www.atlassian.com/git/tutorials/install-git) (Optional)
2. [docker-compose](https://docs.docker.com/compose/install/)
3. Make sure that port 80 of your laptop/desktop does not have a running service.

### Setting up the server
1. Clone the repository to your system.
`git clone https://github.com/lucideus-repo/unsafe-ibank`
2. Navigate to the directory.
`cd unsafe-ibank`
3. Start docker service if not running. 
`sudo service docker start`
3. Start the containers.
`docker-compose up -d`
4. Some pointers to be noted.
- While starting the backend for the very first time, some extra time would be required as the container images would need to be downloaded and built up.
- Each time the command (Step 3) gets successfully completed, some extra 30-40 seconds would be required for the MySQL container to be up and running.
- The SERVER_IP would be the IP Address of the interface to be connected with the device. For example, if the laptop/desktop and the iOS device are connected to the same wifi network, then the SERVER_IP would be the IP address obtained by running the command `ifconfig wlan0` on Linux.


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
