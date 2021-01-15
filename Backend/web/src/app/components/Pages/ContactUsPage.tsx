import React, { Fragment, useEffect } from "react";
import { useState } from "react";
import { useDispatch } from "react-redux";

import { Row, Col, FormGroup, Input, Button } from "reactstrap";
import routes from "../../routes";
import { Card } from "reactstrap";
import svgImage6 from "../../assets/images/illustrations/contactUs.svg";
import SuccessModal from "../SuccessModal";
import handleContactUsThunk from "../../thunks/handleContactUsThunk";
import { toast } from "react-toastify";

const ContactUsPage = () => {
  let userData = JSON.parse(localStorage.getItem("userData")!);

  if (localStorage.length === 0 || !userData) {
    window.location.assign(routes.app.authentication.login);
  }
  const [showModal, setShowModal] = useState(false);
  const [modalMessage, setModalMessage] = useState("");

  const [state, setState] = useState({
    name: "",
    email: "",
    message: ""
  });
  const dispatch = useDispatch();

  const validateEmail = (email: string) => {
    const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(email).toLowerCase());
  };

  useEffect(() => {
    setState({
      name: "",
      email: "",
      message: ""
    });
  }, [showModal]);
  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setState({
      ...state,
      [event.target.name]: event.target.value.trim()
    });
  };
  return (
    <div>
      <Fragment>
        <Card className="card-box">
          <Row className="no-gutters justify-content-center vertical-center">
            <Col lg="5">
              <img
                alt="..."
                className="mx-auto d-block text-center p-5"
                src={svgImage6}
                style={{
                  verticalAlign: "middle",
                  display: "inline-block",
                  height: "70vh"
                }}
              />
            </Col>
            <Col lg="1" />
            <Col lg="5">
              <div className="p-5">
                <h1 className="display-4 my-3 font-weight-bold ">Contact Us</h1>
                <div>
                  <form>
                    <FormGroup>
                      <label>Name</label>
                      <Input
                        id="name"
                        value={state.name}
                        onChange={handleChange}
                        name="name"
                      />
                    </FormGroup>
                    <FormGroup>
                      <label>Email</label>
                      <Input
                        type="email"
                        id="email"
                        value={state.email}
                        name="email"
                        onChange={handleChange}
                      />
                    </FormGroup>
                    <FormGroup>
                      <label>Message</label>
                      <Input
                        type="textarea"
                        id="message"
                        name="message"
                        value={state.message}
                        onChange={handleChange}
                      />
                    </FormGroup>

                    <br />
                    <Button
                      disabled={
                        !(!!state.name && !!state.email && !!state.message)
                      }
                      size="lg"
                      block={true}
                      color="second"
                      onClick={() => {
                        if (validateEmail(state.email)) {
                          dispatch(
                            handleContactUsThunk({
                              state,
                              token: userData.token as string,
                              setShowModal,
                              setModalMessage
                            })
                          );
                        } else {
                          toast.error("Email address is not valid", {
                            position: "top-center"
                          });
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
          heading={modalMessage}
          showModal={showModal}
          handleOkayButton={() => {
            setShowModal(false);
          }}
        />
      </Fragment>
    </div>
  );
};

export default ContactUsPage;
