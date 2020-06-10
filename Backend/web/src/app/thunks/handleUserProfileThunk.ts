import { Dispatch } from "redux";
import axios from "axios";
import routes from "../routes";
import userprofileSlice from "../slices/UserProfileSlice";
import { toast } from "react-toastify";

const handleUserProfile = ({
  userid,
  token
}: {
  token: string;
  userid: string;
}) => (dispatch: Dispatch) => {
  dispatch(userprofileSlice.actions.setLoading);
  axios
    .post(routes.api.userProfile, {
      requestBody: {
        timestamp: new Date(),
        token: token,
        data: {
          userid: userid
        }
      }
    })
    .then(response => {
      if (response.data.status !== "Failed") {
        dispatch(userprofileSlice.actions.setLoaded());
        dispatch(userprofileSlice.actions.setUserInfomation(response.data.data));
      } else {
        dispatch(userprofileSlice.actions.setLoadingFailed());
      }
    }).catch(res=>(toast.error("Backend Server is unresponsive.",{position: "top-center"})));
};

export default handleUserProfile;
