import axios from "axios";
import routes from "../../routes";
import { Dispatch } from "redux";
import viewBeneficiariesSlice from "../../slices/ViewBeneficiarySlice";
import { toast } from "react-toastify";
import { getHeaders } from "../configHelper";

const handleBeneficiaryDetails = ({ token, alias }: { token: string; alias: string }) => (dispatch: Dispatch) => {
  axios
    .post(routes.api.beneficiary.beneficiaryDetails, {
      requestBody: {
        timestamp: "325553",
        device: {
          deviceid: "UHDGGF735SVHFVSX",
          os: "ios",
          host: "lucideustech.com"
        },
        data: {
          alias: alias
        }
      }
    },getHeaders(token))
    .then(response => {
      if (response.data.status !== "Failed") {
        dispatch(viewBeneficiariesSlice.actions.setBeneficiaryDetails(response.data.data));
        dispatch(viewBeneficiariesSlice.actions.setIsSuccess(true));
      } else {
        dispatch(viewBeneficiariesSlice.actions.setErrorMessage(response.data.message));
        dispatch(viewBeneficiariesSlice.actions.setIsSuccess(false));
      }
    })
    .catch(res => toast.error("Backend Server is unresponsive.", { position: "top-center" }));
};

export default handleBeneficiaryDetails;
