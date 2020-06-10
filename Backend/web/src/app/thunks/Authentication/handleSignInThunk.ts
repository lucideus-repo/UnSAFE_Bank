import { Dispatch } from "redux";
import { History } from "history";
import axios from "axios";
import routes from "../../routes";
import AuthenticationSlice from "../../slices/LoginSlice";
import { toast } from "react-toastify";

const handleSignInThunk = ({
  email,
  password
}: {
  email: string | null;
  password: string | null;
  history: History;
}) => (dispatch: Dispatch) => {
  dispatch(AuthenticationSlice.actions.setCorrectDetail());

  var body = {
    requestBody: {
      timestamp: "325553",
      device: {
        deviceid: "UHDGGF735SVHFVSX",
        os: "ios",
        host: "lucideustech.com"
      },
      data: {
        userid: email,
        passwd: password
      }
    }
  };
  axios
    .post(routes.api.authentication.login, body)
    .then(response => {
      if (response.data.status !== "Failed") {
        localStorage.setItem("userData", JSON.stringify(response.data.data));
        dispatch(AuthenticationSlice.actions.setCorrectDetail());

        window.location.assign(routes.app.dashboard);
      } else if (localStorage.length !== 0 && localStorage.getItem("userData")) {
        window.location.assign(routes.app.dashboard);
      } else {
        if (response.data.message === "Already logged in. Wait for some time")
          toast.error("User already logged in.\nPlease try after some time.", {
            position: "top-center",
            autoClose: 4000
          });
        else dispatch(AuthenticationSlice.actions.setWrongDetail());
      }
    })
    .catch(res => toast.error("Backend Server is unresponsive.", { position: "top-center" }));
};

export default handleSignInThunk;
