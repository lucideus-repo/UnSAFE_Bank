import { Dispatch } from "redux";
import axios from "axios";
import routes from "../../routes";
import { toast } from "react-toastify";
import { getHeaders } from "../configHelper";

const handleAddBeneficiary = (
  accountNumber: string,
  ifscCode: string,
  alias: string,
  otpResponse: string,
  token: string
) => (dispatch: Dispatch) => {
  axios
    .post(routes.api.beneficiary.addBeneficiary, {
      requestBody: {
        timestamp: "325553",
        device: {
          deviceid: "UHDGGF735SVHFVSX",
          os: "ios",
          host: "lucideustech.com"
        },
        data: {
          account_number: accountNumber,
          ifsc_code: ifscCode,
          alias: alias,
          otp_response: otpResponse
        }
      }
    },getHeaders(token))
    .then((response) => {
      if (response.data.status !== "Failed") {
        toast.success(
          "Beneficiary added Successful.\n Taking you back to Dashboard Page.",
          {
            position: "top-center"
          }
        );

        window.setInterval(() => window.location.assign(routes.app.dashboard), 5000);
        
      } else {
        toast.error(response.data.message, {
          position: "top-center"
        });
      }
    })
    .catch((res) =>
      toast.error("Backend Server is unresponsive.", { position: "top-center" })
    );
};

export default handleAddBeneficiary;
