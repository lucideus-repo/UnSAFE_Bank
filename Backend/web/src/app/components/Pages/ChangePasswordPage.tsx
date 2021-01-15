import React, { Fragment, useEffect } from "react";
import { useState } from "react";
import { useDispatch } from "react-redux";

import { Row, Col, FormGroup, Input, Button } from "reactstrap";
import routes from "../../routes";
import { Card } from "reactstrap";
import svgImage6 from "../../assets/images/illustrations/changePassword.svg";
import { toast } from "react-toastify";
import handleChangePasswordThunk from "../../thunks/handleChangePasswordThunk";
import SuccessModal from "../SuccessModal";

const ChangePasswordPage = () => {
  let userData = JSON.parse(localStorage.getItem("userData")!);

  if (localStorage.length === 0 || !userData) {
    window.location.assign(routes.app.authentication.login);
  }
  const [showModal, setShowModal] = useState(false);

  const [state, setState] = useState({
    currentPassword: "",
    newPassword: "",
    renewPassword: ""
  });
  const dispatch = useDispatch();
  useEffect(() => {
    setState({
      currentPassword: "",
      newPassword: "",
      renewPassword: ""
    });
  }, [showModal]);
  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setState({
      ...state,
      [event.target.name]: event.target.value.trim()
    });
  };
  const placeholder = '●●●●●●●●'
  return (
    <div>
      <Fragment>
        <Card className="card-box">
          <Row className="no-gutters justify-content-center">
            <Col lg="5">
              <img
                alt="..."
                className="mx-auto d-block text-center p-5"
                src={svgImage6}
                style={{
                  verticalAlign: "middle",
                  display: "inline-block",
                  height: "60vh"
                }}
              />
            </Col>
            <Col lg="1" />
            <Col lg="5">
              <div className="p-5">
                <h1 className="display-4 my-3 font-weight-bold ">
                  Change Password
                </h1>
                <div>
                  <form>
                    <FormGroup>
                      <label>Current Password</label>
                      <Input
                        type="password"
                        placeholder={placeholder}
                        id="currentPassword"
                        value={state.currentPassword}
                        onChange={handleChange}
                        name="currentPassword"
                      />
                    </FormGroup>
                    <FormGroup>
                      <label>New Password</label>
                      <Input
                        type="password"
                        placeholder={placeholder}
                        id="newPassword"
                        value={state.newPassword}
                        name="newPassword"
                        onChange={handleChange}
                      />
                    </FormGroup>
                    <FormGroup>
                      <label>Re-Enter New Password</label>
                      <Input
                        type="password"
                        placeholder={placeholder}
                        id="renewPassword"
                        name="renewPassword"
                        value={state.renewPassword}
                        onChange={handleChange}
                      />
                    </FormGroup>

                    <br />
                    <Button
                      disabled={
                        !(
                          !!state.currentPassword &&
                          !!state.newPassword &&
                          !!state.renewPassword
                        )
                      }
                      size="lg"
                      block={true}
                      color="second"
                      onClick={() => {
                        const {
                          currentPassword,
                          newPassword,
                          renewPassword
                        } = state;
                        if (newPassword !== renewPassword) {
                          toast.error("New Password doesnot match.", {
                            position: "top-center"
                          });
                        } else {
                          dispatch(
                            handleChangePasswordThunk({
                              state: { currentPassword, newPassword },
                              token: userData.token as string,
                              setShowModal
                            })
                          );
                        }
                      }}
                    >
                      Continue
                    </Button>
                  </form>
                </div>
              </div>
            </Col>
          </Row>
        </Card>
        <SuccessModal
          heading="Password Change Successfully."
          showModal={showModal}
          handleOkayButton={() => {
            setShowModal(false);
          }}
        />
      </Fragment>
    </div>
  );
};

export default ChangePasswordPage;
