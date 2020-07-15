import React, { Fragment } from "react";
import { useState } from "react";
import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";
import { RouteComponentProps } from "react-router";
import { AddBeneficiaryState } from "../../../store/ReduxState";
import { withRouter } from "react-router-dom";
import { Row, Col, FormGroup, Input, Button } from "reactstrap";
import handleAddBeneficiaryGetOTPThunk from "../../../thunks/OTP/handleGetOTPThunk";
import addBeneficiarySlice from "../../../slices/AddBeneficiarySlice";
import handleAddBeneficiaryVerifyOTPThunk from "../../../thunks/OTP/handleVerifyOTPThunk";
import handleAddBeneficiaryThunk from "../../../thunks/Beneficiary/handleAddBeneficiaryThunk";
import routes from "../../../routes";
import { Card } from "reactstrap";
import svgImage6 from "../../../assets/images/illustrations/presentation-blocks.svg";
import { toast } from "react-toastify";

interface Props extends RouteComponentProps<any> {
  addBeneficiary: AddBeneficiaryState;
  handleResetOTP: () => void;
  handleGetOTP: (token: string, type: string) => void;
  handleVerifyOTP: (token: string, OTP: string, type: string) => void;
  handleAddBeneficiary: (
    accountNumber: string,
    ifscCode: string,
    alias: string,
    otpResponse: string,
    token: string
  ) => void;
}
const AddBeneficiaryPage = ({
  history,
  handleGetOTP,
  addBeneficiary,
  handleResetOTP,
  handleVerifyOTP,
  handleAddBeneficiary
}: Props) => {
  let userData = JSON.parse(localStorage.getItem("userData")!);

  if (localStorage.length === 0 || !userData) {
    window.location.assign(routes.app.authentication.login);
  }
//@ts-ignore
  history.listen((location, action) => {
    handleResetOTP();
  });

  const [globalAccountNumber, setGlobalAccountNumber] = useState("");
  const [globalAlias, setGlobalAlias] = useState("");
  const [globalIFSCCode, setGlobalIFSCCode] = useState("");

  const GetAccountDetailStage = () => {
    const [accountNumber, setAccountNumber] = useState("");
    const [verifyAccountNumber, setVerifyAccountNumber] = useState("");
    const [alias, setAlias] = useState("");
    const [ifscCode, setifscCode] = useState("");

    let accountNumberValidate = (evt: any) => {
      var theEvent = evt || window.event;
      var key = theEvent.keyCode || theEvent.which;
      key = String.fromCharCode(key);

      var regex = /[0-9]|\./;
      if (!regex.test(key)) {
        theEvent.returnValue = false;
        if (theEvent.preventDefault) theEvent.preventDefault();
      }
    };

    return (
      <div>
        <form>
          <FormGroup>
            <label>Account Number</label>
            <Input
              type="text"
              onKeyPress={e => accountNumberValidate(e)}
              placeholder="Enter 12 digit Account Number "
              id="Account"
              onChange={e => {
                setAccountNumber(e.target.value.trim());
              }}
            />
          </FormGroup>
          <FormGroup>
            <label>Re-Enter Account Number</label>
            <Input
              type="text"
              onKeyPress={e => accountNumberValidate(e)}
              placeholder="Enter 12 digit Account Number"
              id="Account"
              onChange={e => {
                setVerifyAccountNumber(e.target.value.trim());
              }}
            />
          </FormGroup>
          <FormGroup>
            <label>Alias</label>
            <Input
              placeholder="John"
              id="username"
              onChange={e => {
                setAlias(e.target.value.replace(/\s/g,'').trim());
              }}
            />
          </FormGroup>
          <FormGroup>
            <label>IFSC Code <label className="text-muted">eg.IFSC00002</label></label>
            <Input
              placeholder="IFSCXXXXX"
              id="username"
              onChange={e => {
                setifscCode(e.target.value.trim());
              }}
            />
          </FormGroup>
          <br />
          <Button
            disabled={!(!!accountNumber && !!alias && !!ifscCode)}
            size="lg"
            block={true}
            color="second"
            onClick={() => {
              if (accountNumber !== verifyAccountNumber) {
                toast.error("Account Number doesnot match.", {
                  position: "top-center"
                });
              } else {
                setGlobalAccountNumber(accountNumber);
                setGlobalAlias(alias);
                setGlobalIFSCCode(ifscCode);
                handleGetOTP(userData.token, "1");
              }
            }}
          >
            Continue
          </Button>
        </form>
      </div>
    );
  };

  const OTPStage = () => {
    const [OTP, setOTP] = useState("");

    let otpValidate = (evt: any) => {
      var theEvent = evt || window.event;
      var key = theEvent.keyCode || theEvent.which;
      key = String.fromCharCode(key);

      var regex = /[0-9]|\./;
      if (!regex.test(key)) {
        theEvent.returnValue = false;
        if (theEvent.preventDefault) theEvent.preventDefault();
      }
    };
    return (
      <div>
        <form>
          <FormGroup>
            <label>OTP</label>
            <Input
              type="text"
              onKeyPress={e => otpValidate(e)}
              maxLength={6}
              placeholder="OTP"
              id="OTP"
              onChange={e => setOTP(e.target.value.trim())}
            />
            <Button
              color="link"
              className="float-right p-0"
              onClick={e => {
                toast.info(
                  () => (
                    <div>
                      Your One Time Password is{" "}
                      <b> {addBeneficiary.OTPDecoded}</b>. Do not share this OTP
                      for security reasons.
                    </div>
                  ),
                  {
                    autoClose: 10000
                  }
                );
              }}
            >
              Resend OTP?
            </Button>
            <br />
          </FormGroup>
          <Button
            disabled={!(OTP.length === 6)}
            size="lg"
            block={true}
            color="second"
            onClick={() => {
              handleVerifyOTP(userData.token, OTP, "1");
            }}
          >
            Continue
          </Button>
        </form>
      </div>
    );
  };

  let handleRender = () => {
    if (addBeneficiary.OTPDecoded === "" && addBeneficiary.OTPResponse === "") {
      return <GetAccountDetailStage />;
    } else if (
      addBeneficiary.OTPDecoded !== "" &&
      addBeneficiary.OTPResponse === ""
    ) {
      return <OTPStage />;
    } else {
      handleAddBeneficiary(
        globalAccountNumber,
        globalIFSCCode,
        globalAlias,
        addBeneficiary.OTPResponse,
        userData.token
      );
      handleResetOTP();
      return <GetAccountDetailStage />;
    }
  };

  return (
    <div>
      <Fragment>
        <Card className="card-box">
          <Row className="no-gutters justify-content-center">
            <Col lg="5">
              <img
                alt="..."
                className="mx-auto d-block text-center h-100"
                src={svgImage6}
              />
            </Col>
            <Col lg="1" />
            <Col lg="5">
              <div className="p-5">
                <h1 className="display-4 my-3 font-weight-bold ">
                  Add Beneficiary
                </h1>
                {handleRender()}
              </div>
            </Col>
          </Row>
        </Card>
      </Fragment>
    </div>
  );
};

const mapStateToProps = (state: { addBeneficiary: AddBeneficiaryState }) => {
  return {
    addBeneficiary: state.addBeneficiary
  };
};

const mapDispatchToProps = (dispatch: Dispatch) => {
  return bindActionCreators(
    {
      handleResetOTP: addBeneficiarySlice.actions.setResetOTP,
      handleGetOTP: handleAddBeneficiaryGetOTPThunk,
      handleVerifyOTP: handleAddBeneficiaryVerifyOTPThunk,
      handleAddBeneficiary: handleAddBeneficiaryThunk
    },
    dispatch
  );
};

export default withRouter(
  connect(mapStateToProps, mapDispatchToProps)(AddBeneficiaryPage)
);
