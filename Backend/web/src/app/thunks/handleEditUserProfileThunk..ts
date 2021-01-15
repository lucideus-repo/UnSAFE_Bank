import { Dispatch } from "redux";
import axios from "axios";
import routes from "../routes";
import userprofileSlice from "../slices/UserProfileSlice";
import { toast } from "react-toastify";
import { getHeaders } from "./configHelper";

interface editState {
  firstName: string;
  lastName: string;
  email: string;
  address: string;
  mobileNumber: string;
  avatar: string;
}
const handleEditUserProfileThunk = ({
  state,
  token,
  setShowModal
}: {
  token: string;
  state: editState;
  setShowModal: (isOpen: boolean) => void;
}) => (dispatch: Dispatch) => {
  const {
    firstName,
    lastName,
    email,
    address,
    mobileNumber: mobile,
    avatar
  } = state;
  dispatch(userprofileSlice.actions.setLoading);
  axios
    .post(routes.api.user.editProfile, {
      requestBody: {
        timestamp: new Date(),
        data: {
          firstName,
          lastName,
          email,
          mobile: Number(mobile),
          address,
          avatar
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
    .catch((res) =>
      toast.error("Backend Server is unresponsive.", { position: "top-center" })
    );
};

export default handleEditUserProfileThunk;
