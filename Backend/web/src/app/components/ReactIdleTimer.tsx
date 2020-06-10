import React, { useState, useRef } from "react";
import IdleTimer from "react-idle-timer";
import { Modal, Button } from "reactstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import handleSignOutThunk from "../thunks/Authentication/handleSignOutThunk";
import { connect } from "react-redux";
import { RouteComponentProps, withRouter } from "react-router-dom";
import { Dispatch, bindActionCreators } from "redux";

interface Props extends RouteComponentProps<any> {
  handleSignOut: (args: { token: string }) => void;
}

let ReactIdleTimer = ({ handleSignOut }: Props) => {
  let userData = JSON.parse(localStorage.getItem("userData")!);

  let onClickSignOut = (payload: string) => {
    handleSignOut({
      token: payload
    });
  };

  const [modalIsOpen, setModalIsOpen] = useState(false);
  const idleTimerRef = useRef(null);
  const onIdle = () => {
    setModalIsOpen(true);
  };
  const onOkay = () => {
    setModalIsOpen(false);
    onClickSignOut(userData.token);
  };

  return (
    <>
      <IdleTimer ref={idleTimerRef} timeout={1000 * 3 * 60} onIdle={onIdle} />
      <Modal zIndex={2000} centered isOpen={modalIsOpen} toggle={onOkay}>
        <div className="text-center p-5">
          <div className="avatar-icon-wrapper rounded-circle m-0">
            <div className="d-inline-flex justify-content-center p-0 rounded-circle avatar-icon-wrapper bg-neutral-first text-first m-0 d-130">
              <FontAwesomeIcon icon={["fas", "sign-out-alt"]} className="d-flex align-self-center display-3" />
            </div>
          </div>
          <h4 className="font-weight-bold mt-4" style={{ color: "black" }}>
            Session Expired.
          </h4>
          <p className="mb-0 text-black-50">Please login again to continue.</p>
          <div className="pt-4">
            <Button onClick={onOkay} color="second" className="btn-pill mx-1">
              <span className="btn-wrapper--label">OKAY</span>
            </Button>
          </div>
        </div>
      </Modal>
    </>
  );
};

const mapStateToProps = () => {
  return {};
};
const mapDispatchToProps = (dispatch: Dispatch) => {
  return bindActionCreators(
    {
      handleSignOut: handleSignOutThunk
    },
    dispatch
  );
};

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(ReactIdleTimer));
