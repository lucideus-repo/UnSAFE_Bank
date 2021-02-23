import React, { Fragment } from "react";
import { useState } from "react";
import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";
import { RouteComponentProps } from "react-router";
import { History } from "history";
import { LoginState } from "../../../store/ReduxState";
import handleSignInThunk from "../../../thunks/Authentication/handleSignInThunk";
import { Link } from "react-router-dom";
import loginSlice from "../../../slices/LoginSlice";
import { Row, Col, FormGroup, Input, Button } from "reactstrap";
import Swal from "sweetalert2";
import "sweetalert2/src/sweetalert2.scss";
import svgImage9 from "../../../assets/images/illustrations/modern_professional.svg";
import ErrorModal from "../../ErrorModal";
import routes from "../../../routes";
import axios from "axios";

interface Props extends RouteComponentProps<any> {
  history: History;
  login: LoginState;
  handleSignIn: (args: {
    email: string | null;
    password: string | null;
    history: History;
  }) => void;

  handleSignOut: (args: { token: string }) => void;
  handleWrongPassword: () => void;
}

const AuthenticationPage = ({
  history,
  handleSignIn,
  login,
  handleWrongPassword
}: Props) => {
  if (!!localStorage.getItem("userData") && localStorage.length !== 0) {
    window.location.assign(routes.app.dashboard);
  }
  let onClickSignIn = (email: string, password: string) => {
    handleSignIn({
      email: email,
      password: password,
      history: history
    });
  };
  let onTestConnection = () => {
    Swal.mixin({
      input: "text",
      confirmButtonText: "Next &rarr;",
      showCloseButton: true,
      inputAttributes: {
        autocapitalize: "off"
      },
      confirmButtonColor: "#3D476E",
      allowOutsideClick: () => !Swal.isLoading()
    })
      .queue(["IP Address", "Port"])
      .then(async (result: any) => {
        try {
          const response = await axios(
            "http://" + result.value[0] + ":" + result.value[1] + "/api/"
          );
          if (!response.data) {
            throw new Error(response.data);
          }
          localStorage.setItem("ipAddress", result.value[0]);
          localStorage.setItem("port", result.value[1]);
          Swal.fire({
            icon: "success",
            title: "Connection Established",
            showConfirmButton: true,
            confirmButtonColor: "#3D476E"
          }).then(() => window.location.reload());

          return response;
        } catch (error) {
          if (
            !(
              error.toString() ===
                "TypeError: Cannot read property '0' of undefined" ||
              error.toString() === "TypeError: result.value is undefined"
            )
          )
            Swal.fire({
              icon: "error",
              title: "Connection not Established",
              showConfirmButton: true,
              confirmButtonColor: "#3D476E"
            });
        }
      })
      .catch(() => {
        Swal.fire({
          icon: "error",
          title: "Connection not Established",
          showConfirmButton: false,
          timer: 1500
        });
      });
  };
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  let isUserDetailsCorrect = () => {
    if (login.isDetailCorrect === true) return true;
    else if (login.isDetailCorrect === false) {
      return false;
    }
  };

  return (
    <div>
      <Fragment>
        {isUserDetailsCorrect() ? null : (
          <ErrorModal
            showModal={true}
            errorHeading="Either Customer ID or Password is incorrect!"
            handleOkayButton={handleWrongPassword}
          />
        )}
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
                                  Login to your account
                                </h1>
                                <p className="font-size-lg text-lg-left text-center mb-0 text-black-50">
                                  We're glad to see you here
                                </p>
                              </span>
                              <div className="bg rounded p my-3"></div>
                              <div>
                                <form>
                                  <FormGroup>
                                    <label>Customer ID</label>
                                    <Input
                                      placeholder="BNKXXXXX"
                                      id="username"
                                      onChange={(e) =>
                                        setUsername(e.target.value.trim())
                                      }
                                    />
                                  </FormGroup>
                                  <div className="form-group mb-4">
                                    <div className="d-flex justify-content-between">
                                      <label>Password</label>
                                      <Link
                                        to={routes.app.authentication.forgot}
                                      >
                                        Forgot password?
                                      </Link>
                                    </div>
                                    <Input
                                      placeholder="Enter your password"
                                      type="password"
                                      id="password"
                                      onChange={(e) =>
                                        setPassword(e.target.value)
                                      }
                                    />
                                  </div>

                                  <Button
                                    disabled={!(password && username)}
                                    size="lg"
                                    block={true}
                                    color="second"
                                    onClick={() => {
                                      onClickSignIn(username, password);
                                    }}
                                  >
                                    Login
                                  </Button>
                                </form>
                              </div>
                              <div className="text-center pt-4 text-black-50">
                                Don't have an account?{" "}
                                <Link to={routes.app.authentication.signup}>
                                  Click here to Sign Up
                                </Link>
                              </div>
                              {!!+process.env.REACT_APP_ENABLE_TEST_CONNECTION!&& (
                                <div className="text-center pt-4 text-black-50">
                                  <Button
                                    onClick={onTestConnection}
                                    color="link"
                                  >
                                    Test Connection?
                                  </Button>
                                </div>
                              )}
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

const mapStateToProps = (state: { login: LoginState }) => {
  return {
    login: state.login
  };
};

const mapDispatchToProps = (dispatch: Dispatch) => {
  return bindActionCreators(
    {
      handleSignIn: handleSignInThunk,
      handleWrongPassword: loginSlice.actions.setCorrectDetail
    },
    dispatch
  );
};

export default connect(mapStateToProps, mapDispatchToProps)(AuthenticationPage);
