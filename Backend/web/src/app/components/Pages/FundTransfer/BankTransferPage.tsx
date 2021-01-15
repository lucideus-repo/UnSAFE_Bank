import React, { Fragment, useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Row, Col, FormGroup, Input, Button, Card, Modal } from "reactstrap";
import { RouteComponentProps, withRouter } from "react-router-dom";
import { BankTransferState } from "../../../store/ReduxState";
import handleBeneficiaryForFundTransfer from "../../../thunks/BankTransfer/handleBeneficiaryForFundTransferThunk";
import handleBankFundTransferThunk from "../../../thunks/BankTransfer/handleBankFundTransferThunk";
import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";
import LoadingBar from "../../LoadingBar";
import handleBankTransferVerifyOTPThunk from "../../../thunks/OTP/handleVerifyOTPThunk";
import handleBankTransferGetOTPThunk from "../../../thunks/OTP/handleGetOTPThunk";
import bankTransferSlice from "../../../slices/BankTransferSlice";
import { History } from "history";
import svgImage6 from "../../../assets/images/illustrations/hero-images.svg";
import { toast } from "react-toastify";

interface Props extends RouteComponentProps<any> {
  bankTransfer: BankTransferState;
  handleBeneficiariesAlias: (args: { token: string }) => void;
  handleResetOTP: () => void;
  handleResetReferenceNumber: () => void;
  handleResetModal: () => void;

  handleGetOTP: (token: string, type: string) => void;
  handleVerifyOTP: (token: string, OTP: string, type: string) => void;
  handleBankFundTransfer: (
    token: string,
    alias: string,
    amount: string,
    remarks: string,
    otpRespose: string
  ) => void;
  history: History;
}

const BankTransferPage = ({
  history,
  bankTransfer,
  handleResetOTP,
  handleResetReferenceNumber,
  handleResetModal,
  handleGetOTP,
  handleVerifyOTP,
  handleBankFundTransfer,
  handleBeneficiariesAlias
}: Props) => {
  let userData = JSON.parse(localStorage.getItem("userData")!);
  if (localStorage.length === 0 || !userData) {
    document.location.href = "/";
  }
  //@ts-ignore
  history.listen((location, action) => {
    handleResetOTP();
  });

  const [globalAlias, setGlobalAlias] = useState("");
  const [globalAmount, setGlobalAmount] = useState("");
  const [globalRemarks, setGlobalRemarks] = useState("");

  let amountValidate = (evt: any) => {
    let theEvent = evt || window.event;
    let key = theEvent.keyCode || theEvent.which;
    key = String.fromCharCode(key);

    let regex = /[0-9]|\./;
    if (
      !regex.test(key) ||
      (theEvent.target.value.includes(".") && key === ".")
    ) {
      theEvent.returnValue = false;
      if (theEvent.preventDefault) theEvent.preventDefault();
    }
  };

  let onClickBeneficiariesAlias = (payload: string) => {
    handleBeneficiariesAlias({
      token: payload
    });
  };
  if (bankTransfer.loading === false && bankTransfer.count === -1) {
    onClickBeneficiariesAlias(userData.token);
    return (
      <div>
        <LoadingBar />
      </div>
    );
  } else if (bankTransfer.count > 0) {
    const GetAccountDetailStage = () => {
      const [alias, setAlias] = useState("");
      const [amount, setAmount] = useState("");
      const [remarks, setRemarks] = useState("");

      let getAlias = (date: string) => {
        let newAlias: any = date.split(" ");
        return newAlias[0];
      };

      let getDisplayAlias = (date: string) => {
        let newAlias: any = date.split(" ");
        return newAlias[0] + " -  XXXXXXXX" + newAlias[2].slice(-4);
      };

      return (
        <div>
          <form>
            <FormGroup>
              <label>Account Number - Primary</label>
              <Input disabled placeholder={userData.acctNo} id="Account" />
            </FormGroup>
            <FormGroup>
              <label>Select Beneficiary</label>
              <Input
                type="select"
                name="select"
                id="exampleSelect"
                onChange={(e) => setAlias(e.target.value)}
              >
                <option />
                {bankTransfer.beneficiaryAlias.map((d) => (
                  <option key={d} value={getAlias(d)}>
                    {getDisplayAlias(d)}
                  </option>
                ))}
              </Input>
            </FormGroup>
            <FormGroup>
              <label>Description</label>
              <Input
                id="username"
                onChange={(e) => {
                  setRemarks(e.target.value.trim());
                }}
              />
            </FormGroup>
            <FormGroup>
              <label>Amount</label>
              <Input
                type="number"
                placeholder="0.00"
                min={0}
                id="username"
                onKeyPress={(e) => amountValidate(e)}
                onChange={(e) => {
                  setAmount(e.target.value);
                }}
              />
            </FormGroup>

            <br />
            <Button
              disabled={!(alias && amount && remarks)}
              size="lg"
              block={true}
              color="second"
              onClick={() => {
                setGlobalAlias(alias);
                setGlobalAmount(amount);
                setGlobalRemarks(remarks);
                handleGetOTP(userData.token, "3");
              }}
            >
              Continue
            </Button>
          </form>
        </div>
      );
    };

    const OTPStage = () => {
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

      const [OTP, setOTP] = useState("");
      return (
        <div>
          <form>
            <FormGroup>
              <label>OTP</label>
              <Input
                type="text"
                onKeyPress={(e) => otpValidate(e)}
                maxLength={6}
                placeholder="OTP"
                onChange={(e) => setOTP(e.target.value)}
              />
              <Button
                color="link"
                className="float-right p-0"
                onClick={(e) => {
                  toast.info(
                    () => (
                      <div>
                        Your One Time Password is{" "}
                        <b>{bankTransfer.OTPDecoded}</b>. Do not share this OTP
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
            </FormGroup>
            <br />
            <Button
              disabled={!(OTP.length === 6)}
              size="lg"
              block={true}
              color="second"
              onClick={() => {
                handleVerifyOTP(userData.token, OTP, "3");
              }}
            >
              Continue
            </Button>
          </form>
        </div>
      );
    };

    let handleRender = () => {
      if (bankTransfer.OTPDecoded === "" && bankTransfer.OTPResponse === "") {
        return <GetAccountDetailStage />;
      } else if (
        bankTransfer.OTPDecoded !== "" &&
        bankTransfer.OTPResponse === ""
      ) {
        return <OTPStage />;
      } else {
        handleBankFundTransfer(
          userData.token,
          globalAlias,
          globalAmount,
          globalRemarks,
          bankTransfer.OTPResponse
        );
        handleResetOTP();
        return <GetAccountDetailStage />;
      }
    };
    const toggle1 = () => {
      handleResetModal();
      handleResetReferenceNumber();
    };

    return (
      <Fragment>
        <Card className="card-box">
          <Row className="no-gutters justify-content-center">
            <Col lg="5">
              <img
                alt="..."
                className="mx-auto d-block text-center h-100 p-4"
                src={svgImage6}
              />
            </Col>
            <Col lg="1" />
            <Col lg="5">
              <div className="p-5">
                <h1 className="display-4 my-3 font-weight-bold ">
                  Bank Transfer
                </h1>
                {handleRender()}

                <Modal zIndex={2000} centered isOpen={bankTransfer.showModal}>
                  <div className="text-center p-5">
                    <div className="avatar-icon-wrapper rounded-circle m-0">
                      <div className="d-inline-flex justify-content-center p-0 rounded-circle avatar-icon-wrapper bg-neutral-success text-success m-0 d-130">
                        <FontAwesomeIcon
                          icon={["far", "check-circle"]}
                          className="d-flex align-self-center display-3"
                        />
                      </div>
                    </div>
                    <h4 className="font-weight-bold mt-4">
                      Fund Transfer Complete.
                    </h4>
                    <p className="mb-0 font-size-lg">
                      Reference Number : {bankTransfer.referenceNumber}
                    </p>
                    <div className="pt-4">
                      <Button
                        onClick={toggle1}
                        color="second"
                        className="btn-pill mx-1"
                      >
                        <span className="btn-wrapper--label">OKAY</span>
                      </Button>
                    </div>
                  </div>
                </Modal>
              </div>
            </Col>
          </Row>
        </Card>
      </Fragment>
    );
  } else {
    return (
      <div>
        <h1>NO RECORD FOUND</h1>
      </div>
    );
  }
};

const mapStateToProps = (state: { bankTransfer: BankTransferState }) => {
  return {
    bankTransfer: state.bankTransfer
  };
};

const mapDispatchToProps = (dispatch: Dispatch) => {
  return bindActionCreators(
    {
      handleBeneficiariesAlias: handleBeneficiaryForFundTransfer,
      handleResetOTP: bankTransferSlice.actions.setResetOTP,
      handleResetReferenceNumber:
        bankTransferSlice.actions.resetReferenceNumber,
      handleResetModal: bankTransferSlice.actions.resetModal,
      handleGetOTP: handleBankTransferGetOTPThunk,
      handleVerifyOTP: handleBankTransferVerifyOTPThunk,
      handleBankFundTransfer: handleBankFundTransferThunk
    },
    dispatch
  );
};

export default withRouter(
  connect(mapStateToProps, mapDispatchToProps)(BankTransferPage)
);
