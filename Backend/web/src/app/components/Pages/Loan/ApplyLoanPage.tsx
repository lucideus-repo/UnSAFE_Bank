import React, { Fragment, useEffect } from "react";
import { useState } from "react";
import { useDispatch } from "react-redux";

import { Row, Col, FormGroup, Input, Button } from "reactstrap";
import routes from "../../../routes";
import { Card } from "reactstrap";
import svgImage6 from "../../../assets/images/illustrations/applyLoan.svg";
import SuccessModal from "../../SuccessModal";
import handleApplyLoanThunk from "../../../thunks/Loan/handleApplyLoanThunk";
import { toast } from "react-toastify";
import Swal from "sweetalert2";

const ApplyLoanPage = () => {
  let userData = JSON.parse(localStorage.getItem("userData")!);

  if (localStorage.length === 0 || !userData) {
    window.location.assign(routes.app.authentication.login);
  }
  const [showModal, setShowModal] = useState(false);
  const [modalMessage, setModalMessage] = useState("");

  const [state, setState] = useState({
    amount: "",
    tenure: "",
    type: "",
    customerId: ""
  });
  const dispatch = useDispatch();
  useEffect(() => {
    setState({
      amount: "",
      tenure: "",
      type: "",
      customerId: ""
    });
  }, [showModal]);

  let monthValidate = (evt: any) => {
    let theEvent = evt || window.event;
    let key = theEvent.keyCode || theEvent.which;
    key = String.fromCharCode(key);
    let regex = /[0-9]|\./;
    if (!regex.test(key) || key === ".") {
      theEvent.returnValue = false;
      if (theEvent.preventDefault) theEvent.preventDefault();
    }
  };
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
                <h1 className="display-4 my-3 font-weight-bold ">
                  Apply for Loan
                </h1>
                <div>
                  <form>
                    <FormGroup>
                      <label>Amount</label>
                      <Input
                        onKeyPress={(e) => amountValidate(e)}
                        value={state.amount}
                        onChange={handleChange}
                        name="amount"
                        placeholder="1000.00"
                      />
                    </FormGroup>
                    <FormGroup>
                      <label>Tenure (Months)</label>
                      <Input
                        id="tenure"
                        value={state.tenure}
                        name="tenure"
                        placeholder="Please Enter Tenure (Months)"
                        onKeyPress={(e) => monthValidate(e)}
                        onChange={handleChange}
                      />
                    </FormGroup>
                    <FormGroup>
                      <label>Type</label>
                      <Input
                        type="select"
                        id="type"
                        name="type"
                        value={state.type}
                        onChange={handleChange}
                      >
                        <option className="mb-4" value="null">
                          Loan Type
                        </option>
                        <option value="Car Loan">Car Loan</option>
                        <option value="Home Loan">Home Loan</option>
                        <option value="Personal Loan">Personal Loan</option>
                      </Input>
                    </FormGroup>

                    <br />
                    <Button
                      disabled={
                        !(state.type && state.amount && state.tenure) ||
                        state.type === "null"
                      }
                      size="lg"
                      block={true}
                      color="second"
                      onClick={() => {
                        if (Number(state.amount) < 1) {
                          toast.error(
                            "Please enter loan amount greater than zero",
                            {
                              position: "top-center"
                            }
                          );
                          return;
                        }

                        if (Number(state.tenure) < 1) {
                          toast.error("Please enter a valid Tenure", {
                            position: "top-center"
                          });
                          return;
                        }
                        {
                          const formatter = new Intl.NumberFormat("en-US", {
                            style: "currency",
                            currency: userData.currency ?? "USD",
                            minimumFractionDigits: 2
                          });
                          Swal.fire({
                            title: "Review Details",
                            html: `<table class="text-nowrap mb-0 ml-5 table table-borderless">
                            <tbody>
                            <tr>
                            <td class="text-left">Amount :</td>
                            <td class="text-left">${formatter.format(
                              Number(state.amount)
                            )}
                            </td>
                            </tr>
                            <tr>
                            <td class="text-left">Tenure :</td>
                            <td class="text-left">${state.tenure} Months</td>
                            </tr>
                            <tr>
                            <td class="text-left">Loan Type :</td>
                            <td class="text-left">${state.type}</td>
                            </tr>
                            </tbody>
                            </table>`,
                            icon: "info",
                            showCancelButton: true,
                            confirmButtonColor: "#3D476E",
                            cancelButtonColor: "#d33",
                            confirmButtonText: "Confirm",
                            reverseButtons: true
                          }).then((result) => {
                            if (result.value) {
                              dispatch(
                                handleApplyLoanThunk({
                                  state: {
                                    ...state,
                                    customerId: userData.userid
                                  },
                                  token: userData.token as string,
                                  setShowModal,
                                  setModalMessage
                                })
                              );
                            }
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

export default ApplyLoanPage;
