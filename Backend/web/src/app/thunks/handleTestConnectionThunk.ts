import { Dispatch } from "redux";
import axios from "axios";
import authenticationSlice from "../slices/LoginSlice";
// import routes from "../routes";
import { toast } from "react-toastify";

const handleTestConnection = () => (
  dispatch: Dispatch
) => {
  axios
    .get("", {
     
    })
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

export default handleTestConnection;
