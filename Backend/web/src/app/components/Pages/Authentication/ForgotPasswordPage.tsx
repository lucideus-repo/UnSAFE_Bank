import React, { Fragment } from "react";
import { useState } from "react";
import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";
import { RouteComponentProps } from "react-router";
import { ForgotPasswordState } from "../../../store/ReduxState";
import { Link } from "react-router-dom";
import { Row, Col, FormGroup, Input, Button } from "reactstrap";
import svgImage9 from "../../../assets/images/illustrations/modern_professional.svg";
import handleForgotPasswordGetOTPThunk from "../../../thunks/Authentication/ForgotPassword/handleForgotPasswordGetOTPThunk";
import forgotPasswordSlice from "../../../slices/ForgotPasswordSlice";
import handleForgotPasswordVerifyOTPThunk from "../../../thunks/Authentication/ForgotPassword/handleForgotPasswordVerifyOTPThunk";
import handleForgotPasswordChangePasswordThunk from "../../../thunks/Authentication/ForgotPassword/handleForgetPasswordChangePasswordThunk";
import { toast } from "react-toastify";
import routes from "../../../routes";

interface Props extends RouteComponentProps<any> {
  forgotPassword: ForgotPasswordState;
  handleResetOTP: () => void;
  handleForgotPassword: (username: string) => void;
  handleVerifyUser: (userid: string, otp: string) => void;
  handleForgotPasswordChangePassword: (
    userid: string,
    OTPResponse: string,
    password: string
  ) => void;
}
const ForgotPasswordPage = ({
  handleForgotPassword,
  forgotPassword,
  handleResetOTP,
  handleVerifyUser,
  handleForgotPasswordChangePassword
}: Props) => {
  if (localStorage.length !== 0 && localStorage.getItem("userData")) {
    window.location.assign(routes.app.dashboard);
  }

  const [username, setUsername] = useState("");
  const BankIDStage = () => {
    const [userid, setUserid] = useState("");
    return (
      <div>
        <form>
          <FormGroup>
            <label>Customer ID</label>
            <Input
              placeholder="BNKXXXXX"
              id="username"
              onChange={e => {
                setUserid(e.target.value.trim());
              }}
            />
          </FormGroup>
          <br />
          <Button
            disabled={!userid}
            size="lg"
            block={true}
            color="second"
            onClick={() => {
              setUsername(userid);
              handleForgotPassword(userid);
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
              id="username"
              onChange={e => setOTP(e.target.value)}
            />
            <Button
              color="link"
              className="float-right p-0"
              onClick={e => {
                toast.info(
                  () => (
                    <div>
                      Your One Time Password is{" "}
                      <b> {forgotPassword.OTPDecoded}</b>. Do not share this OTP
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
              handleVerifyUser(username, OTP);
            }}
          >
            Continue
          </Button>
        </form>
      </div>
    );
  };

  const ResetStage = () => {
    const [password, setPassword] = useState("");

    return (
      <div>
        <form>
          <FormGroup>
            <label>New Password</label>
            <Input
              placeholder="Password"
              id="username"
              type="password"
              onChange={e => setPassword(e.target.value)}
            />
          </FormGroup>
          <br />
          <Button
            size="lg"
            block={true}
            color="second"
            onClick={() => {
              handleForgotPasswordChangePassword(
                username,
                forgotPassword.OTPResponse,
                password
              );
            }}
          >
            Continue
          </Button>
        </form>
      </div>
    );
  };

  let handleRender = () => {
    if (forgotPassword.OTPDecoded === "" && forgotPassword.OTPResponse === "") {
      return <BankIDStage />;
    } else if (
      forgotPassword.OTPDecoded !== "" &&
      forgotPassword.OTPResponse === ""
    ) {
      return <OTPStage />;
    } else {
      return <ResetStage />;
    }
  };

  return (
    <div>
      <Fragment>
        <div className="app-wrapper min-vh-100">
          <div className="app-main min-vh-100">
            <div className="app-content p-0">
              <div className="app-content--inner d-flex align-items-center">
                <div className="flex-grow-1 w-100 d-flex align-items-center">
                  <div className="bg-composed-wrapper--content py-5">
                    <div className="container">
                      <Row>
                        <Col
                          lg="5"
                          className="d-none d-lg-flex align-items-center"
                        >
                          <img
                            alt="..."
                            className="w-100 mx-auto d-block img-fluid"
                            src={svgImage9}
                          />
                        </Col>
                        <Col
                          lg="7"
                          sm="12"
                          className=" d-flex align-items-center"
                        >
                          <div className="pl-0 pl-md-5">
                            <div className="text-black mt-3">
                              <span className="text-left text-sm-center">
                                <h1 className="display-3 text-lg-left text-center mb-3 font-weight-bold">
                                  Forgot Password
                                </h1>
                                <p className="font-size-lg text-lg-left text-center mb-0 text-black-50">
                                  Continue below to reset password of your
                                  <br /> bank account
                                </p>
                              </span>
                              <div className="bg rounded p my-3">
                                <Row />
                              </div>

                              {handleRender()}
                              <div className="text-center pt-4 text-black-50">
                                Do have an account?{" "}
                                <Link onClick={() => handleResetOTP()} to="/">
                                  Click here to Login
                                </Link>
                              </div>
                            </div>
                          </div>
                        </Col>
                      </Row>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </Fragment>
    </div>
  );
};

const mapStateToProps = (state: { forgotPassword: ForgotPasswordState }) => {
  return {
    forgotPassword: state.forgotPassword
  };
};

const mapDispatchToProps = (dispatch: Dispatch) => {
  return bindActionCreators(
    {
      handleResetOTP: forgotPasswordSlice.actions.setResetOTP,
      handleForgotPassword: handleForgotPasswordGetOTPThunk,
      handleVerifyUser: handleForgotPasswordVerifyOTPThunk,
      handleForgotPasswordChangePassword: handleForgotPasswordChangePasswordThunk
    },
    dispatch
  );
};

export default connect(mapStateToProps, mapDispatchToProps)(ForgotPasswordPage);
