import { Dispatch } from "redux";
import axios from "axios";
import routes from "../routes";
import { toast } from "react-toastify";
import { getHeaders } from "./configHelper";

interface State {
  name: string;
  email: string;
  message: string;
}
const handleContactUsThunk = ({
  state,
  token,
  setShowModal,
  setModalMessage
}: {
  token: string;
  state: State;
  setShowModal: (isOpen: boolean) => void;
  setModalMessage: (isOpen: string) => void;
}) => (dispatch: Dispatch) => {
  axios
    .post(
      routes.api.contactUs,
      {
        requestBody: {
          timestamp: new Date(),
          data: { ...state }
        }
      },
      getHeaders(token)
    )
    .then((response) => {

      if (response.data.status !== "Failed") {
        setShowModal(true);
        setModalMessage(response.data.message);
      } else {
        toast.error(response.data.message, { position: "top-center" });
      }
    })
    .catch(() =>
      toast.error("Backend Server is unresponsive.", { position: "top-center" })
    );
};

export default handleContactUsThunk;
