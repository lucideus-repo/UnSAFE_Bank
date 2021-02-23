import { Dispatch } from "redux";
import axios from "axios";
import routes from "../../routes";
import { toast } from "react-toastify";
import deleteBeneficiarySlice from "../../slices/DeleteBeneficiarySlice";
import Swal from "sweetalert2";
import { getHeaders } from "../configHelper";

const handleDeleteBeneficiary = (
  alias: string,
  otpResponse: string,
  token: string
) => (dispatch: Dispatch) => {
  axios
    .post(
      routes.api.beneficiary.deleteBeneficiary,
      {
        requestBody: {
          timestamp: new Date(),
          data: {
            alias: alias,
            otp_response: otpResponse
          }
        }
      },
      getHeaders(token)
    )
    .then((response) => {
      if (response.data.status !== "Failed") {
        dispatch(deleteBeneficiarySlice.actions.setisSuccessful(true));

        Swal.fire({
          title: "Beneficiary Deleted!",
          html: "Your beneficiary has been deleted.",
          icon: "success",
          confirmButtonColor: "#3D476E"
        });
      } else {
        dispatch(deleteBeneficiarySlice.actions.setisSuccessful(true));

        Swal.fire({
          title: "Beneficiary not Deleted!",
          html: response.data.message,
          icon: "warning",
          confirmButtonColor: "#3D476E"
        });
      }
    })
    .catch((res) =>
      toast.error("Backend Server is unresponsive.", { position: "top-center" })
    );
};

export default handleDeleteBeneficiary;
