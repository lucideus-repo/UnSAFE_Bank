import React, { Fragment } from "react";
import { useState } from "react";
import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";
import { RouteComponentProps } from "react-router";
import { SignUpState } from "../../../store/ReduxState";
import handleSignUpThunk from "../../../thunks/Authentication/handleSignUpThunk";
import { Link } from "react-router-dom";

import {
  Button,
  Row,
  Col,
  FormGroup,
  Input,
  Label,
  UncontrolledTooltip,
  Badge
} from "reactstrap";

import svgImage9 from "../../../assets/images/illustrations/modern_professional.svg";
import routes from "../../../routes";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Modal } from "reactstrap";
import CopyToClipboard from "react-copy-to-clipboard";
import SignUpSlice from "../../../slices/SignUpSlice";
import { toast } from "react-toastify";

interface Props extends RouteComponentProps<any> {
  signUp: SignUpState;
  handleSignUp: (args: { newData: any }) => void;
}

const SignUpPage = ({ handleSignUp, signUp }: Props) => {
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [gender, setGender] = useState("");
  const [mobile, setMobile] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [address, setAddress] = useState("");
  const [dob, setDob] = useState("");
  const [isCopied, setIsCopied] = useState(false);

  let onClickSignUp = (e: any) => {
    e.preventDefault();
    let newData = {
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      mobile: mobile,
      email: email,
      password: password,
      countryId: "IND",
      address: address,
      dob: dob
    };

    handleSignUp({ newData });
    window.scrollTo(0, 0);
  };

  const [modal1, setModal1] = useState(true);
  const onClickOkayButton = () => {
    SignUpSlice.actions.setReset();
    setModal1(!modal1);
    window.location.assign(routes.app.authentication.login);
  };
  let getDate = () => {
    let today: any = new Date();
    let dd: any = today.getDate();
    let mm: any = today.getMonth() + 1;
    let yyyy: any = today.getFullYear() - 17;
    if (dd < 10) {
      dd = "0" + dd;
    }
    if (mm < 10) {
      mm = "0" + mm;
    }

    today = yyyy + "-" + mm + "-" + dd;
    return today;
  };
  let mobileValidate = (evt: any) => {
    var theEvent = evt || window.event;
    var key = theEvent.keyCode || theEvent.which;
    key = String.fromCharCode(key);

    var regex = /[0-9]|\./;
    if (!regex.test(key)) {
      theEvent.returnValue = false;
      if (theEvent.preventDefault) theEvent.preventDefault();
    }
  };
  const disabled = !(
    firstName &&
    lastName &&
    gender &&
    mobile &&
    email &&
    password &&
    address &&
    dob
  )
    ? true
    : false;

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
                                  Sign Up
                                </h1>
                                <p className="font-size-lg text-lg-left text-center mb-0 text-black-50">
                                  Fill in the fields below and you'll be good to
                                  go
                                  {signUp.userId ? (
                                    <Fragment>
                                      <Modal
                                        zIndex={2000}
                                        centered
                                        isOpen={modal1}
                                        contentClassName="modal"
                                      >
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
                                            Congratulations!
                                          </h4>

                                          <div className="justify-content-center ">
                                            <span className="mt-10 font-size-lg">
                                              Customer ID&nbsp;&nbsp;
                                              <Badge
                                                color="neutral-success"
                                                className="mt-1 mb-3 text-success font-size-xxl px-4 py-1 h-auto"
                                              >
                                                {signUp.userId}
                                              </Badge>
                                            </span>
                                            <CopyToClipboard
                                              text={signUp.userId}
                                              onCopy={() => setIsCopied(true)}
                                            >
                                              <Button
                                                size="sm"
                                                color="success"
                                                className="btn-transition-none"
                                                id="ClickToCopyTooltip"
                                              >
                                                <FontAwesomeIcon
                                                  icon={["fas", "copy"]}
                                                />
                                              </Button>
                                            </CopyToClipboard>
                                            <UncontrolledTooltip
                                              placement="top"
                                              container=".modal"
                                              target="ClickToCopyTooltip"
                                            >
                                              {!isCopied
                                                ? "Copy to Clipboard"
                                                : "Copied to Clipboard"}
                                            </UncontrolledTooltip>

                                            {!isCopied ? (
                                              <UncontrolledTooltip
                                                placement="left"
                                                container=".modal"
                                                target="proceedToLogin"
                                              >
                                                Please copy your Customer ID to
                                                continue.
                                              </UncontrolledTooltip>
                                            ) : null}
                                          </div>
                                          <br />
                                          <p className="mb-0 font-size-md">
                                            Please take a note of your Customer
                                            ID for future references.
                                          </p>
                                          <div className="pt-4">
                                            <Button
                                              disabled={!isCopied}
                                              onClick={onClickOkayButton}
                                              color="second"
                                              className="btn-pill mx-1"
                                              id="proceedToLogin"
                                            >
                                              <span className="btn-wrapper--label">
                                                Proceed to Login
                                              </span>
                                            </Button>
                                          </div>
                                        </div>
                                      </Modal>
                                    </Fragment>
                                  ) : null}
                                </p>
                              </span>
                              <div className="bg rounded p my-3">
                                <Row />
                              </div>
                              <div>
                                <form onSubmit={onClickSignUp}>
                                  <FormGroup>
                                    <label>First Name</label>
                                    <Input
                                      placeholder="John"
                                      id="firstName"
                                      name="aman"
                                      onChange={(e) =>
                                        setFirstName(e.target.value.trim())
                                      }
                                    />
                                  </FormGroup>

                                  <FormGroup>
                                    <label>Last Name</label>
                                    <Input
                                      placeholder="Doe"
                                      id="lastName"
                                      onChange={(e) =>
                                        setLastName(e.target.value.trim())
                                      }
                                    />
                                  </FormGroup>
                                  <FormGroup>
                                    <Label for="exampleSelect">Gender</Label>
                                    <Input
                                      type="select"
                                      name="select"
                                      id="exampleSelect"
                                      onChange={(e) =>
                                        setGender(e.target.value)
                                      }
                                    >
                                      <option />
                                      <option value="1">Male</option>
                                      <option value="2">Female</option>
                                      <option value="3">Others</option>
                                    </Input>
                                  </FormGroup>

                                  <FormGroup>
                                    <label>Mobile</label>
                                    <Input
                                      placeholder="XXXXXXXXXX"
                                      id="mobile"
                                      maxLength={10}
                                      onKeyPress={(e) => mobileValidate(e)}
                                      onChange={(e) =>
                                        setMobile(e.target.value.trim())
                                      }
                                    />
                                  </FormGroup>

                                  <FormGroup>
                                    <label>Email</label>
                                    <Input
                                      placeholder="user@email.com"
                                      type="email"
                                      id="email"
                                      onChange={(e) =>
                                        setEmail(e.target.value.trim())
                                      }
                                    />
                                  </FormGroup>

                                  <FormGroup>
                                    <label>Password</label>
                                    <Input
                                      placeholder="●●●●●●●●"
                                      type="password"
                                      id="password"
                                      onChange={(e) =>
                                        setPassword(e.target.value)
                                      }
                                    />
                                  </FormGroup>

                                  <FormGroup>
                                    <label>Address</label>
                                    <Input
                                      placeholder=""
                                      id="address"
                                      onChange={(e) =>
                                        setAddress(e.target.value.trim())
                                      }
                                    />
                                  </FormGroup>
                                  <FormGroup>
                                    <label>Date of Birth</label>
                                    <Input
                                      id="dob"
                                      type="date"
                                      max={getDate()}
                                      onChange={(e) => setDob(e.target.value)}
                                    />
                                  </FormGroup>
                                  <Button
                                    onClick={(e) => {
                                      if (disabled) {
                                        toast.error(
                                          "Please fill all the fields",
                                          { position: "top-center" }
                                        );
                                        return;
                                      }
                                      onClickSignUp(e);
                                    }}
                                    size="lg"
                                    block={true}
                                    color="second"
                                    id="submitButtonDiv"
                                    className={disabled ? "disabled" : ""}
                                  >
                                    Sign Up
                                  </Button>
                                </form>
                              </div>
                              <div className="text-center pt-4 text-black-50">
                                Already have an account?{" "}
                                <Link to={routes.app.authentication.login}>
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
const mapStateToProps = (state: { signUp: SignUpState }) => {
  return {
    signUp: state.signUp
  };
};

const mapDispatchToProps = (dispatch: Dispatch) => {
  return bindActionCreators(
    {
      handleSignUp: handleSignUpThunk
    },
    dispatch
  );
};

export default connect(mapStateToProps, mapDispatchToProps)(SignUpPage);
