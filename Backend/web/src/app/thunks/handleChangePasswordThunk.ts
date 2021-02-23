import { Dispatch } from "redux";
import axios from "axios";
import routes from "../routes";
import userprofileSlice from "../slices/UserProfileSlice";
import { toast } from "react-toastify";
import { getHeaders } from "./configHelper";

interface State {
  currentPassword: string;
  newPassword: string;
}
const handleEditUserProfileThunk = ({
  state,
  token,
  setShowModal
}: {
  token: string;
  state: State;
  setShowModal: (isOpen: boolean) => void;
}) => (dispatch: Dispatch) => {
  const { currentPassword, newPassword } = state;
  dispatch(userprofileSlice.actions.setLoading);
  axios
    .post(routes.api.changePassword, {
      requestBody: {
        timestamp: new Date(),
        data: {
          old_pass: currentPassword,
          new_pass: newPassword
        }
      }
    },getHeaders(token))
    .then((response) => {
      if (response.data.status !== "Failed") {
        setShowModal(true);
      } else {
        toast.error(response.data.message, { position: "top-center" });
      }
    })
    .catch(() =>
      toast.error("Backend Server is unresponsive.", { position: "top-center" })
    );
};

export default handleEditUserProfileThunk;
