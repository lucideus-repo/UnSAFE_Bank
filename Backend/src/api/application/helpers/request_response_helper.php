<?php

function check_value($obj)
{
    echo "<pre>";
    print_r($obj);
    echo "</pre>";
    die;
}

class status_codes
{

    const RequestFormatOk = array(
        'status_code' => 'ALLOK2',
        'message' => 'Request format is correct'
    );
    const ImproperRequestFormat = array(
        'status_code' => 'ERR001',
        'message' => 'JSON in request parameter is improperly formatted'
    );
    const RequestParameterNotSet = array(
        'status_code' => 'ERR002',
        'message' => 'One of the request parameters is not set'
    );
    const InvalidFormatOfRequestBody = array(
        'status_code' => 'ERR003',
        'message' => 'Invalid format of requestBody'
    );
    const InvalidFormatOfTimestamp = array(
        'status_code' => 'ERR004',
        'message' => 'Invalid format of Timestamp parameter'
    );
    const InvalidFormatOfToken = array(
        'status_code' => 'ERR005',
        'message' => 'Invalid format of Token parameter'
    );
    const InvalidSession = array(
        'status_code' => 'ERRO06',
        'message' => 'Session is invalid'
    );
    const ImproperFormatInDeviceParameter = array(
        'status_code' => 'ERR007',
        'message' => 'One of the Device parameters is not set'
    );
    const InvalidFormatOfDeviceId = array(
        'status_code' => 'ERR008',
        'message' => 'Device Id parameter format is not valid'
    );
    const InvalidFormatOfOs = array(
        'status_code' => 'ERR009',
        'message' => 'OS parameter format is not valid'
    );
    const InvalidFormatOfHost = array(
        'status_code' => 'ERR010',
        'message' => 'Host parameter format is not valid'
    );
    const ImproperFormatInDataParameter = array(
        'status_code' => 'ERR011',
        'message' => 'Data parameter format is not valid'
    );
    const DBSyncError = array(
        'status_code' => 'ERR012',
        'message' => 'Error in syncronizing the database'
    );
    const NoToken = array(
        'status_code' => 'ERR013',
        'message' => 'Token is required'
    );
    const DbError = array(
        'status_code' => 'ERR014',
        'message' => 'DB Error. Contact the developer'
    );
    const IncorrectUseridFormat = array(
        'status_code' => 'ERR015',
        'message' => 'Userid format is incorrect'
    );

    // Signup Module
    const SignupFailed = array(
        'status_code' => 'SNUP01',
        'message' => 'Signup Failed. Mobile Number Exists'
    );
    const SignupSuccess = array(
        'status_code' => 'SNUP02',
        'message' => 'Signup Successful'
    );
    const FnameInvalidOrNotSet = array(
        'status_code' => 'SNUP03',
        'message' => 'Parameter fname is invalid or not set'
    );
    const LnameInvalidOrNotSet = array(
        'status_code' => 'SNUP04',
        'message' => 'Parameter lname is invalid or not set'
    );
    const GndrInvalidOrNotSet = array(
        'status_code' => 'SNUP05',
        'message' => 'Parameter gndr is invalid or not set'
    );
    const MobileInvalidOrNotSet = array(
        'status_code' => 'SNUP06',
        'message' => 'Parameter mobile is invalid or not set'
    );
    const EmailInvalidOrNotSet = array(
        'status_code' => 'SNUP07',
        'message' => 'Parameter email is invalid or not set'
    );
    const PasswdInvalidOrNotSet = array(
        'status_code' => 'SNUP08',
        'message' => 'Parameter passwd is invalid or not set'
    );
    const CntryInvalidOrNotSet = array(
        'status_code' => 'SNUP09',
        'message' => 'Parameter countryId is invalid or not set'
    );
    const AddressInvalidOrNotSet = array(
        'status_code' => 'SNUP10',
        'message' => 'Parameter address is invalid or not set'
    );
    const DobInvalidOrNotSet = array(
        'status_code' => 'SNUP11',
        'message' => 'Parameter dob is invalid or not set'
    );
    const MobileAlreadyExists = array(
        'status_code' => 'SNUP11',
        'message' => 'Mobile number already exists'
    );
    const EmailAlreadyExists = array(
        'status_code' => 'SNUP11',
        'message' => 'Email address already exists'
    );
    const MobileOrEmailAlreadyExists = array(
        'status_code' => 'SNUP12',
        'message' => 'Mobile Number or Email address already exists'
    );
    const MobileAndEmailNotExist = array(
        'status_code' => 'SNUP13',
        'message' => 'Mobile Number and Email address available for signup'
    );

    // Login Module
    const LoginError = array(
        'status_code' => 'LGN001',
        'message' => 'Username or Password is incorrect'
    );
    const LoginSuccess = array(
        'status_code' => 'LGN002',
        'message' => 'Login Success'
    );
    const UseridInvalidOrNotSet = array(
        'status_code' => 'LGN003',
        'message' => 'Userid not set or format invalid'
    );
    const LPasswdInvalidOrNotSet = array(
        'status_code' => 'LGN004',
        'message' => 'Passwd not set or format invalid'
    );
    const CoolDownPeriod = array(
        'status_code' => 'LGN005',
        'message' => 'Already logged in. Wait for some time'
    );

    // Logout
    const LogoutSuccess = array(
        'status_code' => 'LGT001',
        'message' => 'Logged out Successfully'
    );

    // My Account
    const AccDetParameterMissing = array(
        'status_code' => 'ACT001',
        'message' => 'One of the Parameters is missing'
    );
    const AccountDetails = array(
        'status_code' => 'ACT002',
        'message' => 'Account details'
    );
    const UserIdDoesNotExist = array(
        'status_code' => 'ACT003',
        'message' => 'User id Does not exit'
    );

    // Add Beneficiary Module
    const BeneficiaryAddSuccess = array(
        'status_code' => 'BNF001',
        'message' => 'Beneficiary Added Successfully'
    );
    const ExistingBeneficaryError = array(
        'status_code' => 'BNF002',
        'message' => 'Beneficiary Already exists'
    );
    const IncorrectAcNoFormat = array(
        'status_code' => 'BNF003',
        'message' => 'Account Number format is incorrect'
    );
    const IncorrectAliasFormat = array(
        'status_code' => 'BNF004',
        'message' => 'Alias format is incorrect'
    );
    const IncorrectIfscFormat = array(
        'status_code' => 'BNF005',
        'message' => 'IFSC format is incorrect'
    );
    const IncorrectEmailFormat = array(
        'status_code' => 'BNF006',
        'message' => 'Email format is incorrect'
    );
    const BeneficiaryAccountNumberNotExist = array(
        'status_code' => 'BNF007',
        'message' => 'Account Number or IFSC Code is Incorrect'
    );
    const BeneficiaryAccountNumberIsSelf = array(
        'status_code' => 'BNF008',
        'message' => 'Cannot add self as beneficiary'
    );
    const BeneficiaryAlreadyExist = array(
        'status_code' => 'BNF009',
        'message' => 'Beneficiary already exists'
    );
    const AliasAlreadyExist = array(
        'status_code' => 'BNF010',
        'message' => 'Alias already exists'
    );

    // List beneficiary
    const BeneficiaryListSuccess = array(
        'status_code' => 'BNF011',
        'message' => 'List of Beneficiaries'
    );

    // Fetch beneficiary details
    const BeneficiaryFetchSuccess = array(
        'status_code' => 'BNF012',
        'message' => 'Bank Details of Beneficiary'
    );

    // Delete Beneficiary
    const BeneficiaryNotExist = array(
        'status_code' => 'BNF013',
        'message' => 'Beneficiary with requested alias does not exist'
    );
    const BeneficiaryDeleteSuccess = array(
        'status_code' => 'BNF014',
        'message' => 'Beneficiary Deleted Successfully'
    );

    // Fund Transfer or Pay Beneficiary
    const PaymentSuccess = array(
        'status_code' => 'BNF015',
        'message' => 'Payment done Successfully'
    );
    const IncorrectAmountFormat = array(
        'status_code' => 'BNF016',
        'message' => 'Amount format is incorrect'
    );
    const IncorrectRemarksFormat = array(
        'status_code' => 'BNF017',
        'message' => 'Remarks format is incorrect'
    );
    const InsufficientBalance = array(
        'status_code' => 'BNF018',
        'message' => 'Account Balance is insufficient for Payment'
    );
    const MinTransactionNotMet = array(
        'status_code' => 'BNF019',
        'message' => 'Transaction failed. Minimum amount is 1.00'
    );

    // OTP
    const OtpGenerated = array(
        'status_code' => 'OTP001',
        'message' => 'OTP Generated Successfully'
    );
    const InvalidOtpType = array(
        'status_code' => 'OTP002',
        'message' => 'Invalid OTP Type Selected'
    );
    const OtpVerifySuccess = array(
        'status_code' => 'OTP003',
        'message' => 'OTP Verification Successful'
    );
    const OtpVerifyFailed = array(
        'status_code' => 'OTP004',
        'message' => 'Incorrect OTP'
    );
    const InvalidOtpFormat = array(
        'status_code' => 'OTP005',
        'message' => 'OTP Length Should be 6 Digits'
    );
    const OtpVerifyNull = array(
        'status_code' => 'OTP006',
        'message' => 'Kindly Generate an OTP first'
    );
    const IncorrectOtpReferenceFormat = array(
        'status_code' => 'OTP007',
        'message' => 'Format of OTP Response is incorrect'
    );
    const InvalidOtpResponse = array(
        'status_code' => 'OTP008',
        'message' => 'OTP Response not valid'
    );
    const OtpSessionMismatch = array(
        'status_code' => 'OTP009',
        'message' => 'OTP Response and Session do not match'
    );
    const InvalidOtpPurpose = array(
        'status_code' => 'OTP010',
        'message' => 'Invalid use of OTP'
    );
    const ExpiredOtpResponse = array(
        'status_code' => 'OTP11',
        'message' => 'OTP Response as expired'
    );

    // Forgot/Change Password
    const InvalidUserIdFormat = array(
        'status_code' => 'PSW001',
        'message' => 'Userid should be alphanumeric'
    );
    const Unregistered = array(
        'status_code' => 'PSW002',
        'message' => 'User not registered'
    );
    const IncorrectPasswordFormat = array(
        'status_code' => 'PSW003',
        'message' => 'Password format is incorrect'
    );
    const PasswordResetSuccess = array(
        'status_code' => 'PSW004',
        'message' => 'Password Reset Successful'
    );
    const NewPasswdOldPasswd = array(
        'status_code' => 'PSW007',
        'message' => 'New Password cannot be same as Old Password'
    );
    const ChangePasswdSuccess = array(
        'status_code' => 'PSW008',
        'message' => 'Password Changed Successfully'
    );
    const OldPassIncorrect = array(
        'status_code' => 'PSW009',
        'message' => 'Old password is incorrect'
    );
    const IncorrectOldPasswordFormat = array(
        'status_code' => 'PSW010',
        'message' => 'Old password format is invalid or not set'
    );
    const IncorrectNewPasswordFormat = array(
        'status_code' => 'PSW011',
        'message' => 'New password format is invalid or not set'
    );

    // statement
    const TranStatement = array(
        'status_code' => 'SMT001',
        'message' => 'Account statement fetched Successfully'
    );
    const InvalidFromDate = array(
        'status_code' => 'SMT002',
        'message' => 'Invalid format of from_date parameter'
    );
    const InvalidToDate = array(
        'status_code' => 'SMT003',
        'message' => 'Invalid format of to_date parameter'
    );
    const InvalidTransType = array(
        'status_code' => 'SMT004',
        'message' => 'Invalid trans_type parameter'
    );
    const ToDateSmaller = array(
        'status_code' => 'SMT005',
        'message' => 'to_date should be more than from_date'
    );
    const DiffMoreThanExpected = array(
        'status_code' => 'SMT006',
        'message' => 'Difference between to_date and from_date should not be more than 180 days'
    );
    // Edit User Module
    const EditFailed = array(
        'status_code' => 'EDIT01',
        'message' => 'Edit Failed.'
    );
    const EditSuccess = array(
        'status_code' => 'EDIT02',
        'message' => 'Edit Successful'
    );
    const FnameInvalid = array(
        'status_code' => 'EDIT03',
        'message' => 'First Name is invalid'
    );
    const LnameInvalid = array(
        'status_code' => 'EDIT04',
        'message' => 'last Name is invalid'
    );
    const MobileInvalid = array(
        'status_code' => 'EDIT06',
        'message' => 'Mobile Number is invalid'
    );

    const EmailInvalid = array(
        'status_code' => 'EDIT07',
        'message' => 'Email is invalid'
    );

    const EditMobileAlreadyExists = array(
        'status_code' => 'EDIT09',
        'message' => 'Mobile Number already exists'
    );

    const EditEmailAlreadyExists = array(
        'status_code' => 'EDIT12',
        'message' => 'Email Address already exists'
    );

    const AddressInvalid = array(
        'status_code' => 'EDIT11',
        'message' => 'Address is invalid'
    );
    const AvatarInvalid = array(
        'status_code' => 'EDIT12',
        'message' => 'Profile Picture link is invalid'
    );
    //Loan

    const FileNameInvalid = array(
        'status_code' => 'LOAN01',
        'message' => 'File Name is invalid'
    );

    const AmountInvalid = array(
        'status_code' => 'LOAN02',
        'message' => 'Loan Amount is invalid'
    );

    const LoanTypeInvalid = array(
        'status_code' => 'LOAN03',
        'message' => 'Loan Type is invalid'
    );

    const ROIInvalid = array(
        'status_code' => 'LOAN04',
        'message' => 'Loan Rate of Interest is invalid'
    );
    const LoanSuccess = array(
        'status_code' => 'LOAN05',
        'message' => 'Loan Successfully Applied'
    );
    const TenureInvalid = array(
        'status_code' => 'LOAN06',
        'message' => 'Tenure is invalid'
    );
}

function prepare_response($status, $code, $msg, $ts, $data)
{
    $resp['status'] = $status;
    $resp['status_code'] = $code;
    $resp['message'] = $msg;
    $resp['timestamp'] = $ts;
    $resp['data'] = $data;
    return json_encode($resp);
}

function getRequestHeaders()
{
    $headers = array();
    foreach ($_SERVER as $key => $value) {
        if (substr($key, 0, 5) <> 'HTTP_') {
            continue;
        }
        $header = str_replace(' ', '-', str_replace('_', ' ', strtolower(substr($key, 5))));
        $headers[$header] = $value;
    }
    return $headers;
}


function validate_params($request)
{
    $status = new status_codes();
    if (
        isset($request['requestBody'])
        and isset($request['requestBody']['timestamp'])
        and isset($request['requestBody']['data'])
    ) {
        // str_replace(find,replace,string,count);
        if (gettype($request['requestBody']) == 'array') {
            // check ts
            if (!preg_match("/^[0-9]{1,15}/", $request['requestBody']['timestamp'])) {
                return $status::InvalidFormatOfTimestamp;
            }

            // check token
            if (isset($request['requestBody']['token']) && !empty($request['requestBody']['token'])) {
                if (!preg_match("/^[A-Z0-9a-z]{20}/", $request['requestBody']['token'])) {
                    return $status::InvalidFormatOfToken;
                }
            }

            // check device
            if (isset($request['requestBody']['device'])) {
                if (gettype($request['requestBody']['device'] == 'array')) {
                    $device = $request['requestBody']['device'];
                    // check deviceid
                    if (!preg_match("/^[A-Z0-9\-]+/", $device['deviceid'])) {
                        return $status::InvalidFormatOfDeviceId;
                    }
                    // check os

                    $OSArray = array("ios", "IOS", "iOS", "android", "Android", "ANDROID");
                    // print();
                    if (isset($device['os'])) {
                        if (!in_array($device['os'], $OSArray)) {
                            return $status::InvalidFormatOfOs;
                        }
                    } else {
                        return $status::RequestParameterNotSet;
                    }
                    // check host
                    if (isset($device['host'])) {
                        if ($device['host'] != "lucideustech.com") {
                            return $status::InvalidFormatOfHost;
                        }
                    } else {
                        return $status::RequestParameterNotSet;
                    }
                } else {
                    return $status::ImproperFormatInDeviceParameter;
                }
            }

            // check data
            if (gettype($request['requestBody']['data'] == 'array')) {
                return $status::RequestFormatOk;
            } else {
                return $status::ImproperFormatInDataParameter;
            }
        } else {
            return $status::ImproperRequestFormat;
        }
    } else {
        return $status::RequestParameterNotSet;
    }
}

function request_parse()
{
    // getting token from headers and setting token as a body param
    $headers = getRequestHeaders();

    $status = new status_codes();
    // initialize
    ini_set('memory_limit', '-1');
    $post = json_decode(file_get_contents('php://input'), true);
    if ($post == null) {
        return $status::ImproperRequestFormat;
    }
    //validate
    if (isset($headers['authorization']) && !empty($headers['authorization'])) {
        $post['requestBody']['token']  = $headers['authorization'];
    }
    $validity = validate_params($post);
    if ($validity['status_code'] != "ALLOK2") {
        return $validity;
    } else {
        $data = array('status_code' => 'ALLOK1');
        foreach ($post['requestBody'] as $key => $value) {
            $data[$key] = $value;
        }
        return $data;
    }
}
