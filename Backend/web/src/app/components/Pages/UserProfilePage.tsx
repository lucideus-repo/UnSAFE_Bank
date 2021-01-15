import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
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
  FormGroup,
  Button,
  UncontrolledTooltip
} from "reactstrap";
import LoadingBar from "../LoadingBar";
import background from "../../assets/img/damir-bosnjak.jpg";
import avatar from "../../assets/img/default-avatar.png";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import routes from "../../routes";
import { useHistory } from "react-router-dom";

const UserProfilePage = () => {
  const history = useHistory();
  const [avatarURL, setAvatarURL] = useState(avatar);
  const dispatch = useDispatch();
  const userProfile = useSelector(
    (reduxState: { userProfile: UserProfileState }) => reduxState.userProfile
  );
  useEffect(() => {
    if (
      userProfile.userProfile &&
      userProfile.userProfile.avatar &&
      userProfile.userProfile.avatar.length
    )
      setAvatarURL(userProfile.userProfile.avatar);
  }, [userProfile]);

  let userData = JSON.parse(localStorage.getItem("userData")!);
  if (localStorage.length === 0 || !userData) {
    document.location.href = "/";
  }

  if (userProfile.loading === false && userProfile.userProfile === null) {
    dispatch(
      handleUserProfileThunk({
        token: userData.token,
        userid: userData.userid
      })
    );
    return (
      <div>
        <LoadingBar />
      </div>
    );
  } else if (userProfile.userProfile) {
    let onClickUserFullName = () => {
      return (
        userProfile.userProfile.fname + " " + userProfile.userProfile.lname
      );
    };

    const {
      fname,
      lname,
      accountBalance,
      accountNumber,
      userId,
      email,
      aadharId,
      incomeTaxNumber,
      mobileNo,
      walletId,
      dob,
      openDate,
      address,
      currency
    } = userProfile.userProfile;

    let getUserGender = () => {
      if (userProfile.userProfile.gender === "1") return "Male";
      else if (userProfile.userProfile.gender === "2") return "Female";
      return "Other";
    };

    let getAccountBalance = (payload: string) => {
      const value = parseFloat(payload);
      const valueDisplay = value.toLocaleString("en-US", {
        style: "currency",
        currency: currency
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
    const createMarkup = () => {
      return {
        __html: address as string
      };
    };

    return (
      <>
        <div className="content">
          <Row>
            <Col md="4">
              <Card className="card-user">
                <div className="image">
                  <img alt="..." src={background} />
                </div>
                <CardBody>
                  <div className="author">
                    <img
                      alt="..."
                      className="avatar border-gray"
                      src={avatarURL}
                      onError={(e) => setAvatarURL(avatar)}
                    />
                    <h5 className="title">{onClickUserFullName()}</h5>
                    <p className="description">@{userId}</p>
                  </div>
                </CardBody>
                <CardFooter>
                  <hr />
                  <div className="button-container">
                    <Row>
                      <Col className="ml-auto mr-auto">
                        <h4>Balance: {getAccountBalance(accountBalance)}</h4>
                      </Col>
                    </Row>
                  </div>
                </CardFooter>
              </Card>
            </Col>
            <Col md="8">
              <Card className="card-user">
                <CardHeader>
                  <CardTitle tag="h4">
                    Personal Information
                    <Button
                      size="sm"
                      color="link"
                      className="sm float-right"
                      id="deleteButton"
                      onClick={() => history.push(routes.app.user.editUser)}
                    >
                      <UncontrolledTooltip
                        placement="top"
                        target="deleteButton"
                      >
                        Edit Profile
                      </UncontrolledTooltip>
                      <FontAwesomeIcon
                        icon={["fas", "edit"]}
                        color="#3b3e66"
                        size="lg"
                      />
                    </Button>
                  </CardTitle>
                </CardHeader>

                <CardBody>
                  <Form>
                    <FormGroup>
                      <Row>
                        <Col className="pr-1" md="4">
                          <label>First Name</label>
                          <h5>{fname}</h5>
                        </Col>
                        <Col className="pr-1" md="3">
                          <label>Last Name</label>
                          <h5>{lname}</h5>
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
                            <h5>{accountNumber}</h5>
                          </div>
                        </Col>
                        <Col className="pr-1" md="3">
                          <label>Customer ID</label>

                          <div>
                            <h5>{userId}</h5>
                          </div>
                        </Col>
                        <Col className="pr-1">
                          <label>Email Address</label>
                          <div>
                            <h5>{email}</h5>
                          </div>
                        </Col>
                      </Row>
                    </FormGroup>
                    <FormGroup>
                      <Row>
                        <Col md="12">
                          <label>Address</label>
                          <h5 dangerouslySetInnerHTML={createMarkup()} />
                        </Col>
                      </Row>
                    </FormGroup>
                    <FormGroup>
                      <Row>
                        <Col className="pr-1" md="4">
                          <label>Aadhar ID</label>
                          <h5>{aadharId}</h5>
                        </Col>
                        <Col className="pr-1" md="4">
                          <label>Income Tax Number</label>
                          <h5>{incomeTaxNumber}</h5>
                        </Col>
                        <Col className="pr-1" md="4">
                          <label>Mobile Number</label>
                          <h5>{mobileNo}</h5>
                        </Col>
                      </Row>
                    </FormGroup>
                    <FormGroup>
                      <Row>
                        <Col className="pr-1" md="4">
                          <label>Wallet ID</label>
                          <h5>{walletId}</h5>
                        </Col>
                        <Col className="pr-1" md="4">
                          <label>Date of Birth</label>
                          <h5>{getDate(dob)}</h5>
                        </Col>
                        <Col className="pr-1" md="4">
                          <label>Account Open Date</label>
                          <h5>{getDate(openDate)}</h5>
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

export default UserProfilePage;
