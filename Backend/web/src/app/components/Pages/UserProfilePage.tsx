import React from "react";
import { bindActionCreators, Dispatch } from "redux";
import { connect } from "react-redux";
import { RouteComponentProps } from "react-router";
import { UserProfileState } from "../../store/ReduxState";
import handleUserProfileThunk from "../../thunks/handleUserProfileThunk";

import {
  Card,
  CardHeader,
  CardBody,
  CardFooter,
  CardTitle,
  Form,
  Row,
  Col,
  FormGroup
} from "reactstrap";
import LoadingBar from "../LoadingBar";
import background from "../../assets/img/damir-bosnjak.jpg";
import avatar from "../../assets/img/default-avatar.png";
interface Props extends RouteComponentProps<any> {
  userProfile: UserProfileState;

  handleUserProfile: (args: { token: string; userid: string }) => void;
}

const UserProfilePage = ({ userProfile, handleUserProfile }: Props) => {
  let userData = JSON.parse(localStorage.getItem("userData")!);
  if (localStorage.length === 0  || !userData) {
    document.location.href = "/";
  }
  let onClickUserProfile = (token: string, userid: string) => {
    handleUserProfile({
      token: token,
      userid: userid
    });
  };

  if (userProfile.loading === false && userProfile.count === -1) {
    onClickUserProfile(userData.token, userData.userid);
    return (
      <div>
          <LoadingBar />
      </div>
    );
  } else if (userProfile.count > 0) {
    let onClickUserFullName = () => {
      return (
        userProfile.userProfile.fname + " " + userProfile.userProfile.lname
      );
    };

    let UserDetails = () => {
      return userProfile.userProfile;
    };

    let getUserGender = () => {
      if (userProfile.userProfile.gender === "1") return "Male";
      else if (userProfile.userProfile.gender === "2") return "Female";
      return "Other";
    };

    let getAccountBalance = (payload: string) => {
      const value = parseFloat(payload);
      const valueDisplay = value.toLocaleString("en-US", {
        style: "currency",
        currency: UserDetails().currency
      });
      return valueDisplay;
    };

    let getDate = (date: string) => {
      const d = new Date(date);
      const dtf = new Intl.DateTimeFormat("en", {
        year: "numeric",
        month: "short",
        day: "2-digit"
      });
      const [
        { value: mo },
        ,
        { value: da },
        ,
        { value: ye }
      ] = dtf.formatToParts(d);

      return `${da}-${mo}-${ye}`;
    };

    return (
      <>
          <div className="content">
            <Row>
              <Col md="4">
                <Card className="card-user">
                  <div className="image">
                    <img
                      alt="..."
                      src={background}
                    />
                  </div>
                  <CardBody>
                    <div className="author">
                      <img
                        alt="..."
                        className="avatar border-gray"
                        src={avatar}
                      />
                      <h5 className="title">{onClickUserFullName()}</h5>
                      <p className="description">@{UserDetails().userId}</p>
                    </div>
                  </CardBody>
                  <CardFooter>
                    <hr />
                    <div className="button-container">
                      <Row>
                        <Col className="ml-auto mr-auto">
                          <h4>
                            Balance:{" "}
                            {getAccountBalance(UserDetails().accountBalance)}
                          </h4>
                        </Col>
                      </Row>
                    </div>
                  </CardFooter>
                </Card>
              </Col>
              <Col md="8">
                <Card className="card-user">
                  <CardHeader>
                    <CardTitle tag="h5">Personal Information</CardTitle>
                  </CardHeader>
                  <CardBody>
                    <Form>
                     
                      <FormGroup>
                      <Row>
                        <Col className="pr-1" md="4">
                          <label>First Name</label>
                          <h5>{UserDetails().fname}</h5>
                        </Col>
                        <Col className="pr-1" md="3">
                          <label>Last Name</label>
                          <h5>{UserDetails().lname}</h5>
                        </Col>
                        <Col className="pr-1" md="3">
                          <label>Gender</label>

                          <div>
                            <h5>{getUserGender()}</h5>
                          </div>
                        </Col>
                      </Row>
                      </FormGroup>
                      <FormGroup>
                      <Row>
                        <Col className="pr-1" md="4">
                          <label>Account Number</label>
                          <div>
                            <h5>{UserDetails().accountNumber}</h5>
                          </div>
                        </Col>
                        <Col className="pr-1" md="3">
                          <label>Customer ID</label>

                          <div>
                            <h5>{UserDetails().userId}</h5>
                          </div>
                        </Col>
                        <Col className="pr-1">
                          <label>Email Address</label>
                          <div>
                            <h5>{UserDetails().email}</h5>
                          </div>
                        </Col>
                      </Row>
                      </FormGroup>
                      <FormGroup>
                      <Row>
                        <Col md="12">
                          <label>Address</label>

                          <h5>{UserDetails().address}</h5>
                        </Col>
                      </Row>
                      </FormGroup>
                      <FormGroup>
                      <Row>
                        <Col className="pr-1" md="4">
                          <label>Aadhar ID</label>
                          <h5>{UserDetails().aadharId}</h5>
                        </Col>
                        <Col className="pr-1" md="4">
                          <label>Income Tax Number</label>
                          <h5>{UserDetails().incomeTaxNumber}</h5>
                        </Col>
                        <Col className="pr-1" md="4">
                          <label>Mobile Number</label>
                          <h5>{UserDetails().mobileNo}</h5>
                        </Col>
                      </Row>
                      </FormGroup>
                      <FormGroup>
                      <Row>
                        <Col className="pr-1" md="4">
                          <label>Wallet ID</label>
                          <h5>{UserDetails().walletId}</h5>
                        </Col>
                        <Col className="pr-1" md="4">
                          <label>Date of Birth</label>
                          <h5>{getDate(UserDetails().dob)}</h5>
                        </Col>
                        <Col className="pr-1" md="4">
                          <label>Account Open Date</label>
                          <h5>{getDate(UserDetails().openDate)}</h5>
                        </Col>
                      </Row>
                      </FormGroup>

                    </Form>
                  </CardBody>
                </Card>
              </Col>
            </Row>
          </div>
      </>
    );
  } else {
    return (
      <div>
          <h1>NO RECORD FOUND</h1>
      </div>
    );
  }
};

const mapStateToProps = (state: { userProfile: UserProfileState }) => {
  return {
    userProfile: state.userProfile
  };
};

const mapDispatchToProps = (dispatch: Dispatch) => {
  return bindActionCreators(
    {
      handleUserProfile: handleUserProfileThunk
    },
    dispatch
  );
};

export default connect(mapStateToProps, mapDispatchToProps)(UserProfilePage);
