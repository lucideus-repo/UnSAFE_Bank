import { Dispatch } from "redux";
import axios from "axios";
import authenticationSlice from "../../slices/LoginSlice";
import routes from "../../routes";
import { toast } from "react-toastify";
import { getHeaders } from "../configHelper";

const handleSignOutThunk = ({ token }: { token: string }) => (
  dispatch: Dispatch
) => {
  axios
    .post(routes.api.authentication.logout, {
      requestBody: {
        timestamp: "325553",
        device: {
          deviceid: "UHDGGF735SVHFVSX",
          os: "ios",
          host: "lucideustech.com"
        },
        data: {}
      }
    },getHeaders(token))
    .then(response => {
      if (response.data.status !== "Failed") {
        dispatch(authenticationSlice.actions.resetState);
        localStorage.removeItem("userData");

      } else {
        alert(response.data.message);
      }
      window.location.assign("/");
    }).catch(res=>(toast.error("Backend Server is unresponsive.",{position: "top-center"})));
};

export default handleSignOutThunk;
