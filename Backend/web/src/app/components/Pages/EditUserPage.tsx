import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { UserProfileState } from "../../store/ReduxState";
import handleUserProfileThunk from "../../thunks/handleUserProfileThunk";
import handleEditUserProfileThunk from "../../thunks/handleEditUserProfileThunk.";

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
  Label,
  Input,
  Button
} from "reactstrap";
import LoadingBar from "../LoadingBar";
import routes from "../../routes";
import SuccessModal from "../SuccessModal";
import { toast } from "react-toastify";

const EditUserProfilePage = () => {
  const userProfile = useSelector(
    (reduxState: { userProfile: UserProfileState }) => reduxState.userProfile
  );

  const [showModal, setShowModal] = useState(false);

  const [state, setState] = useState({
    firstName: "",
    lastName: "",
    email: "",
    address: "",
    mobileNumber: "",
    avatar: ""
  });
  useEffect(() => {
    if (userProfile.userProfile) {
      const {
        fname,
        lname,
        email,
        mobileNo,
        address,
        avatar
      } = userProfile.userProfile;
      setState({
        firstName: fname,
        lastName: lname,
        email,
        address,
        mobileNumber: mobileNo,
        avatar
      });
    }
  }, [userProfile]);

  const dispatch = useDispatch();
  const userData = JSON.parse(localStorage.getItem("userData")!);

  const mobileValidate = (evt: any) => {
    var theEvent = evt || window.event;
    var key = theEvent.keyCode || theEvent.which;
    key = String.fromCharCode(key);

    var regex = /[0-9]|\./;
    if (!regex.test(key)) {
      theEvent.returnValue = false;
      if (theEvent.preventDefault) theEvent.preventDefault();
    }
  };

  if (localStorage.length === 0 || !userData) {
    document.location.href = "/";
  }

  const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setState({
      ...state,
      [event.target.name]: event.target.value
    });
  };

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
    const disabled =
      state.lastName &&
      state.mobileNumber &&
      state.address &&
      state.avatar &&
      state.email &&
      state.firstName
        ? false
        : true;
    return (
      <>
        <div className="content">
          <Row>
            <Col md="6" xs="2" className="offset-3">
              <Card className="card-user">
                <CardHeader>
                  <CardTitle tag="h5">Edit Information</CardTitle>
                </CardHeader>
                <CardBody>
                  <Form>
                    <FormGroup>
                      <Row>
                        <Col>
                          <Label htmlFor="firstName">First Name</Label>
                          <Input
                            type="text"
                            name="firstName"
                            placeholder="Please enter First Name"
                            onChange={handleInputChange}
                            value={state.firstName || ""}
                          />
                        </Col>
                        <Col>
                          <Label htmlFor="lastName">Last Name</Label>
                          <Input
                            type="text"
                            name="lastName"
                            placeholder="Please enter Last Name"
                            onChange={handleInputChange}
                            value={state.lastName || ""}
                          />
                        </Col>
                      </Row>
                    </FormGroup>
                    <FormGroup>
                      <Row>
                        <Col>
                          <Label htmlFor="email">Email Address</Label>
                          <Input
                            type="email"
                            name="email"
                            placeholder="Please enter Email Address"
                            onChange={handleInputChange}
                            value={state.email || ""}
                          />
                        </Col>
                        <Col>
                          <Label htmlFor="mobileNo">Mobile Number</Label>
                          <Input
                            name="mobileNumber"
                            placeholder="Please enter Mobile Number"
                            onChange={handleInputChange}
                            maxLength={10}
                            onKeyPress={(e) => mobileValidate(e)}
                            value={state.mobileNumber || ""}
                          />
                        </Col>
                      </Row>
                    </FormGroup>
                    <FormGroup>
                      <Row>
                        <Col>
                          <Label htmlFor="address">Address</Label>
                          <Input
                            type="text"
                            name="address"
                            placeholder="Please enter Address"
                            onChange={handleInputChange}
                            value={state.address || ""}
                          />
                        </Col>
                      </Row>
                    </FormGroup>
                    <FormGroup>
                      <Row>
                        <Col>
                          <Label htmlFor="avatar">Profile Picture</Label>
                          <Input
                            type="url"
                            name="avatar"
                            placeholder="Please enter profile picture url"
                            onChange={handleInputChange}
                            value={state.avatar || ""}
                          />
                        </Col>
                      </Row>
                    </FormGroup>
                  </Form>
                </CardBody>
                <CardFooter className="mb-2">
                  <span id="submitButtonDiv">
                    <Button
                      id="submitButton"
                      color="second"
                      className={`btn btn-sm float-right ${
                        disabled ? "disabled" : null
                      }`}
                      onClick={(e) => {
                        if (disabled) {
                          toast.error("Please fill all the fields", {
                            position: "top-center"
                          });
                          return;
                        }
                        dispatch(
                          handleEditUserProfileThunk({
                            state,
                            token: userData.token,
                            setShowModal
                          })
                        );
                      }}
                    >
                      Submit
                    </Button>
                  </span>

                  <Button
                    color="warning"
                    className="mr-2 btn btn-sm float-right "
                    onClick={() =>
                      window.location.assign(routes.app.user.userProfile)
                    }
                  >
                    Cancel
                  </Button>
                </CardFooter>
              </Card>
            </Col>
          </Row>
        </div>
        <SuccessModal
          heading="Details changed Successfully."
          handleOkayButton={() =>
            window.location.assign(routes.app.user.userProfile)
          }
          showModal={showModal}
        />
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

export default EditUserProfilePage;
