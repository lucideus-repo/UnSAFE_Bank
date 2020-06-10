import React, { Fragment, useState } from "react";
import { Modal, ModalHeader, ModalBody, Table, Button, UncontrolledTooltip } from "reactstrap";
import { RouteComponentProps, withRouter } from "react-router-dom";
import DeleteBeneficiaryPage from "./Pages/Beneficiary/DeleteBeneficiaryPage";
import Swal from "sweetalert2";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
interface Props extends RouteComponentProps<any> {
  alias?: string | null;
  accountNumber?: string | null;
  IFSC?: string | null;
  creationDate?: string;
  open: boolean;
  successful?: boolean;
  errorMessage?: string;
  handleOkayButton: () => void;
}

const BeneficiaryDetailModal = ({
  alias,
  accountNumber,
  IFSC,
  open,
  creationDate,
  handleOkayButton,
  successful,
  errorMessage
}: Props) => {
  const [modal2, setModal2] = useState(open);
  const [deleteModal, setDeleteModal] = useState(!open);

  const toggle2 = () => {
    handleOkayButton();
    setModal2(!modal2);
    setDeleteModal(false);
  };

  const createMarkup = () => {
    return {
      __html: errorMessage!
    };
  };

  const handleRender = () => {
    if (successful) {
      return deleteModal ? (
        <Modal zIndex={3000} centered size="md" isOpen={modal2} toggle={toggle2}>
          <DeleteBeneficiaryPage onSuccess={toggle2} alias={alias!} />
        </Modal>
      ) : (
        <Modal contentClassName="modal custom-modal" zIndex={2000} centered size="md" isOpen={modal2} toggle={toggle2}>
          <ModalHeader toggle={toggle2}>
            <div className="modal-title-inner">
              <b className="font-size-lg text-black">Beneficiary Details</b>
              <Button
                size="sm"
                color="link"
                className="sm"
                id="deleteButton"
                onClick={e => {
                  Swal.fire({
                    title: "Are you sure?",
                    text: "You won't be able to revert this!",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#3D476E",
                    cancelButtonColor: "#d33",
                    confirmButtonText: "Yes, delete it!"
                  }).then(result => {
                    if (result.value) {
                      setDeleteModal(true);
                    }
                  });
                }}
              >
                <FontAwesomeIcon icon={["fas", "trash"]} color="#e53935" size="lg" />
              </Button>
            </div>

            <UncontrolledTooltip placement="right" container=".modal" target="deleteButton">
              Delete Beneficiary
            </UncontrolledTooltip>
          </ModalHeader>
          <ModalBody>
            <Table borderless className="text-nowrap mb-0">
              <tbody>
                <tr>
                  <td className="text-left">Alias :</td>

                  <td className="text-left">{alias}</td>
                </tr>
                <tr>
                  <td className="text-left">IFSC Code:</td>

                  <td className="text-left">{IFSC}</td>
                </tr>
                <tr>
                  <td className="text-left">Account Number :</td>

                  <td className="text-left">{accountNumber}</td>
                </tr>
                <tr>
                  <td className="text-left">Added Date :</td>
                  <td className="text-left">{creationDate}</td>
                </tr>
              </tbody>
            </Table>
          </ModalBody>
        </Modal>
      );
    } else {
      return (
        <Modal zIndex={2000} centered size="md" isOpen={modal2} toggle={toggle2}>
          <ModalHeader toggle={toggle2}>
            <b className="font-size-lg text-black">Beneficiary Details</b>
          </ModalHeader>
          <ModalBody>
            <div dangerouslySetInnerHTML={createMarkup()} />
          </ModalBody>
        </Modal>
      );
    }
  };
  return <Fragment>{handleRender()}</Fragment>;
};

export default withRouter(BeneficiaryDetailModal);
