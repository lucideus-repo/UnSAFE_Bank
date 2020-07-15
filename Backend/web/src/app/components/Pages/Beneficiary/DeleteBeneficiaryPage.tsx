import React, { Fragment } from "react";
import { useState } from "react";
import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";
import { RouteComponentProps } from "react-router";
import { DeleteBeneficiaryState } from "../../../store/ReduxState";
import { withRouter } from "react-router-dom";
import handleViewBeneficiaries from "../../../thunks/Beneficiary/handleViewBeneficiaryThunk";
import { Row, Col, FormGroup, Input, Button } from "reactstrap";
import handleDeleteBeneficiaryGetOTPThunk from "../../../thunks/OTP/handleGetOTPThunk";
import deleteBeneficiarySlice from "../../../slices/DeleteBeneficiarySlice";
import handleDeleteBeneficiaryVerifyOTPThunk from "../../../thunks/OTP/handleVerifyOTPThunk";
import handleDeleteBeneficiaryThunk from "../../../thunks/Beneficiary/handleDeleteBeneficiaryThunk";
import routes from "../../../routes";
import { toast } from "react-toastify";
import LoadingBar from "../../LoadingBar";

interface Props extends RouteComponentProps<any> {
  deleteBeneficiary: DeleteBeneficiaryState;
  alias: string;
  handleResetOTP: () => void;
  handleBeneficiariesAlias: (args: { token: string }) => void;
  onSuccess: () => void;
  handleGetOTP: (token: string, type: string) => void;
  handleVerifyOTP: (token: string, OTP: string, type: string) => void;
  handleDeleteBeneficiary: (alias: string, otpResponse: string, token: string) => void;
}
const DeleteBeneficiaryPage = ({
  alias,
  history,
  onSuccess,
  handleBeneficiariesAlias,
  handleGetOTP,
  deleteBeneficiary,
  handleResetOTP,
  handleVerifyOTP,
  handleDeleteBeneficiary
}: Props) => {
  let userData = JSON.parse(localStorage.getItem("userData")!);

  if (localStorage.length === 0 || !userData) {
    window.location.assign(routes.app.authentication.login);
  }
//@ts-ignore
  history.listen((location, action) => {
    handleResetOTP();
  });

  let onClickBeneficiariesAlias = (payload: string) => {
    handleBeneficiariesAlias({
      token: payload
    });
  };
  const GetAliasState = () => {
    return (
      <Fragment>
        <Row className="no-gutters justify-content-center">
          <Col>
            <div className="p-5">
              <h1 className="display-4 my-3 font-weight-bold ">Delete Beneficiary</h1>
              <div>
                <form>
                  <FormGroup>
                    <label>Alias</label>
                    <Input disabled id="username" value={alias} />
                  </FormGroup>
                  <br />
                  <Button
                    size="lg"
                    block={true}
                    color="second"
                    onClick={() => {
                      handleGetOTP(userData.token, "2");
                    }}
                  >
                    Continue
                  </Button>
                </form>
              </div>
            </div>
          </Col>
        </Row>
      </Fragment>
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
      <Fragment>
        <Row className="no-gutters justify-content-center">
          <Col>
            <div className="p-5">
              <h1 className="display-4 my-3 font-weight-bold ">Delete Beneficiary</h1>
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
                              Your One Time Password is <b> {deleteBeneficiary.OTPDecoded}</b>. Do not share this OTP
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
                      handleVerifyOTP(userData.token, OTP, "2");
                    }}
                  >
                    Continue
                  </Button>
                </form>
              </div>
            </div>
          </Col>
        </Row>
      </Fragment>
    );
  };

  let handleRender = () => {
    if (deleteBeneficiary.OTPDecoded === "" && deleteBeneficiary.OTPResponse === "") {
      return <GetAliasState />;
    } else if (deleteBeneficiary.OTPDecoded !== "" && deleteBeneficiary.OTPResponse === "") {
      return <OTPStage />;
    } else if (!deleteBeneficiary.isSuccessful) {
      handleDeleteBeneficiary(alias, deleteBeneficiary.OTPResponse, userData.token);
      return <LoadingBar />;
    }
  };
  const app = () => {
    onClickBeneficiariesAlias(userData.token);
    handleResetOTP();
    onSuccess();
  };
  return (
    <div>
      {handleRender()}
      {deleteBeneficiary.isSuccessful ? app() : null}
    </div>
  );
};

const mapStateToProps = (state: { deleteBeneficiary: DeleteBeneficiaryState }) => {
  return {
    deleteBeneficiary: state.deleteBeneficiary
  };
};

const mapDispatchToProps = (dispatch: Dispatch) => {
  return bindActionCreators(
    {
      handleBeneficiariesAlias: handleViewBeneficiaries,
      handleResetOTP: deleteBeneficiarySlice.actions.setResetOTP,
      handleGetOTP: handleDeleteBeneficiaryGetOTPThunk,
      handleVerifyOTP: handleDeleteBeneficiaryVerifyOTPThunk,
      handleDeleteBeneficiary: handleDeleteBeneficiaryThunk
    },
    dispatch
  );
};

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(DeleteBeneficiaryPage));
