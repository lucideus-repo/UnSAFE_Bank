import React, { Fragment, useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Button, Modal } from "reactstrap";
import { RouteComponentProps, withRouter } from "react-router-dom";

interface Props extends RouteComponentProps<any> {
  heading: string;
  description?: string;
  showModal: boolean;
  handleOkayButton?: () => void;
}

const SuccessModal = ({
  heading,
  description,
  showModal,
  handleOkayButton
}: Props) => {
  const [modal2, setModal2] = useState(showModal);

  const toggle2 = () => {
    if (handleOkayButton) handleOkayButton();
    setModal2(!modal2);
  };

  return (
    <Fragment>
      <Modal zIndex={2000} centered isOpen={showModal} backdrop={true}>
        <div className="text-center p-5">
          <div className="avatar-icon-wrapper rounded-circle m-0">
            <div className="d-inline-flex justify-content-center p-0 rounded-circle avatar-icon-wrapper bg-neutral-success text-success m-0 d-130">
              <FontAwesomeIcon
                icon={["far", "check-circle"]}
                className="d-flex align-self-center display-3"
              />
            </div>
          </div>
          <h4 className="font-weight-bold mt-4">{heading}</h4>
          <p className="mb-0 font-size-lg text-muted">{description} </p>
          <div className="pt-4">
            <Button
              onClick={toggle2}
              color="second"
              className="btn-pill mx-1"
            >
              <span className="btn-wrapper--label">Continue</span>
            </Button>
          </div>
        </div>
      </Modal>
    </Fragment>
  );
};

export default withRouter(SuccessModal);
